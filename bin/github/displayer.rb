class Displayer
  attr_accessor :data

  def initialize(data)
    self.data = data
  end

  def histogram(nbins = 20)
    return unless data.size>1
    bins, freqs = data.histogram(nbins)
    bins.zip(freqs).each{|bin, count| puts printf("%5.d | #{"#"*count}", bin.round(2)) }
  end

  def integration(nbins = 20, options = {})
    return unless data.size>1
    bins, freqs = data.histogram(nbins, options)
    dist = bins.zip(freqs).to_h
    dist.each_with_index do |(bin, count), index|
      marks = (dist.values[0..index].inject(0, :+) / data.size.to_f * 50).round
      puts printf("%5.d | #{"#"*marks}", bin.round(2))
    end
  end

end
