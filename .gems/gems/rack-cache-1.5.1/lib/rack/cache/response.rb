require 'time'
require 'set'
require 'rack/response'
require 'rack/utils'
require 'rack/cache/cachecontrol'

module Rack::Cache

  # Provides access to the response generated by the downstream application. The
  # +response+, +original_response+, and +entry+ objects exposed by the Core
  # caching engine are instances of this class.
  #
  # Response objects respond to a variety of convenience methods, including
  # those defined in Rack::Response::Helpers, Rack::Cache::Headers,
  # and Rack::Cache::ResponseHeaders.
  #
  # Note that Rack::Cache::Response is not a subclass of Rack::Response and does
  # not perform many of the same initialization and finalization tasks. For
  # example, the body is not slurped during initialization and there are no
  # facilities for generating response output.
  class Response
    include Rack::Response::Helpers

    # Rack response tuple accessors.
    attr_accessor :status, :headers, :body

    # The time when the Response object was instantiated.
    attr_reader :now

    # Create a Response instance given the response status code, header hash,
    # and body.
    def initialize(status, headers, body)
      @status = status.to_i
      @headers = Rack::Utils::HeaderHash.new(headers)
      @body = body
      @now = Time.now
      @headers['Date'] ||= @now.httpdate
    end

    def initialize_copy(other)
      super
      @headers = other.headers.dup
    end

    # Return the status, headers, and body in a three-tuple.
    def to_a
      [status, headers.to_hash, body]
    end

    # Status codes of responses that MAY be stored by a cache or used in reply
    # to a subsequent request.
    #
    # http://tools.ietf.org/html/rfc2616#section-13.4
    CACHEABLE_RESPONSE_CODES = [
      200, # OK
      203, # Non-Authoritative Information
      300, # Multiple Choices
      301, # Moved Permanently
      302, # Found
      404, # Not Found
      410  # Gone
    ].to_set

    # A Hash of name=value pairs that correspond to the Cache-Control header.
    # Valueless parameters (e.g., must-revalidate, no-store) have a Hash value
    # of true. This method always returns a Hash, empty if no Cache-Control
    # header is present.
    def cache_control
      @cache_control ||= CacheControl.new(headers['Cache-Control'])
    end

    # Set the Cache-Control header to the values specified by the Hash. See
    # the #cache_control method for information on expected Hash structure.
    def cache_control=(value)
      if value.respond_to? :to_hash
        cache_control.clear
        cache_control.merge!(value)
        value = cache_control.to_s
      end

      if value.nil? || value.empty?
        headers.delete('Cache-Control')
      else
        headers['Cache-Control'] = value
      end
    end

    # Determine if the response is "fresh". Fresh responses may be served from
    # cache without any interaction with the origin. A response is considered
    # fresh when it includes a Cache-Control/max-age indicator or Expiration
    # header and the calculated age is less than the freshness lifetime.
    def fresh?
      ttl && ttl > 0
    end

    # Determine if the response is worth caching under any circumstance. Responses
    # marked "private" with an explicit Cache-Control directive are considered
    # uncacheable
    #
    # Responses with neither a freshness lifetime (Expires, max-age) nor cache
    # validator (Last-Modified, ETag) are considered uncacheable.
    def cacheable?
      return false unless CACHEABLE_RESPONSE_CODES.include?(status)
      return false if cache_control.no_store? || cache_control.private?
      validateable? || fresh?
    end

    # Determine if the response includes headers that can be used to validate
    # the response with the origin using a conditional GET request.
    def validateable?
      headers.key?('Last-Modified') || headers.key?('ETag')
    end

    # Mark the response "private", making it ineligible for serving other
    # clients.
    def private=(value)
      value = value ? true : nil
      self.cache_control = cache_control.
        merge('public' => !value, 'private' => value)
    end

    # Indicates that the cache must not serve a stale response in any
    # circumstance without first revalidating with the origin. When present,
    # the TTL of the response should not be overriden to be greater than the
    # value provided by the origin.
    def must_revalidate?
      cache_control.must_revalidate || cache_control.proxy_revalidate
    end

    # Mark the response stale by setting the Age header to be equal to the
    # maximum age of the response.
    def expire!
      headers['Age'] = max_age.to_s if fresh?
    end

    # The date, as specified by the Date header. When no Date header is present,
    # set the Date header to Time.now and return.
    def date
      if date = headers['Date']
        Time.httpdate(date)
      else
        headers['Date'] = now.httpdate unless headers.frozen?
        now
      end
    end

    # The age of the response.
    def age
      (headers['Age'] ||  [(now - date).to_i, 0].max).to_i
    end

    # The number of seconds after the time specified in the response's Date
    # header when the the response should no longer be considered fresh. First
    # check for a r-maxage directive, then a s-maxage directive, then a max-age
    # directive, and then fall back on an expires header; return nil when no
    # maximum age can be established.
    def max_age
      cache_control.reverse_max_age ||
        cache_control.shared_max_age ||
          cache_control.max_age ||
           (expires && (expires - date))
    end

    # The value of the Expires header as a Time object.
    def expires
      headers['Expires'] && Time.httpdate(headers['Expires'])
    rescue ArgumentError
      nil
    end

    # The number of seconds after which the response should no longer
    # be considered fresh. Sets the Cache-Control max-age directive.
    def max_age=(value)
      self.cache_control = cache_control.merge('max-age' => value.to_s)
    end

    # Like #max_age= but sets the s-maxage directive, which applies only
    # to shared caches.
    def shared_max_age=(value)
      self.cache_control = cache_control.merge('s-maxage' => value.to_s)
    end

    # Like #shared_max_age= but sets the r-maxage directive, which applies only
    # to reverse caches.
    def reverse_max_age=(value)
      self.cache_control = cache_control.merge('r-maxage' => value.to_s)
    end

    # The response's time-to-live in seconds, or nil when no freshness
    # information is present in the response. When the responses #ttl
    # is <= 0, the response may not be served from cache without first
    # revalidating with the origin.
    def ttl
      max_age - age if max_age
    end

    # Set the response's time-to-live for shared caches to the specified number
    # of seconds. This adjusts the Cache-Control/s-maxage directive.
    def ttl=(seconds)
      self.shared_max_age = age + seconds
    end

    # Set the response's time-to-live for private/client caches. This adjusts
    # the Cache-Control/max-age directive.
    def client_ttl=(seconds)
      self.max_age = age + seconds
    end

    # The String value of the Last-Modified header exactly as it appears
    # in the response (i.e., no date parsing / conversion is performed).
    def last_modified
      headers['Last-Modified']
    end

    # The literal value of ETag HTTP header or nil if no ETag is specified.
    def etag
      headers['ETag']
    end

    # Headers that MUST NOT be included with 304 Not Modified responses.
    #
    # http://tools.ietf.org/html/rfc2616#section-10.3.5
    NOT_MODIFIED_OMIT_HEADERS = %w[
      Allow
      Content-Encoding
      Content-Language
      Content-Length
      Content-MD5
      Content-Type
      Last-Modified
    ].to_set

    # Modify the response so that it conforms to the rules defined for
    # '304 Not Modified'. This sets the status, removes the body, and
    # discards any headers that MUST NOT be included in 304 responses.
    #
    # http://tools.ietf.org/html/rfc2616#section-10.3.5
    def not_modified!
      body.close if body.respond_to?(:close)
      self.status = 304
      self.body = []
      NOT_MODIFIED_OMIT_HEADERS.each { |name| headers.delete(name) }
      nil
    end

    # The literal value of the Vary header, or nil when no header is present.
    def vary
      headers['Vary']
    end

    # Does the response include a Vary header?
    def vary?
      ! vary.nil?
    end

    # An array of header names given in the Vary header or an empty
    # array when no Vary header is present.
    def vary_header_names
      return [] unless vary = headers['Vary']
      vary.split(/[\s,]+/)
    end

  end
end
