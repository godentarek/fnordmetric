module FnordMetric::GaugeModifiers

  def incr(gauge_name, value=1)
    gauge = fetch_gauge(gauge_name)    
    assure_two_dimensional!(gauge)
    if gauge.progressive?      
      @redis.incrby(gauge.key(:head), value).callback do |head|
        @redis.hsetnx(gauge.key, gauge.tick_at(time), head).callback do |_new|
          @redis.hincrby(gauge.key, gauge.tick_at(time), value) unless _new
        end
      end
    else
      @redis.hincrby(gauge.key, gauge.tick_at(time), value)    
    end
  end  

  def incr_field(gauge_name, field_name, value=1)
    gauge = fetch_gauge(gauge_name)
    assure_three_dimensional!(gauge)
    #here be dragons
  end

end