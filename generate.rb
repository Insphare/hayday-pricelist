beginning = Time.now
separator = '─' * 29 + '┬' + (( '─' * 10 + '┬' ) * 9)

def get_count_special_chars string
  special_chars = string.downcase.count 'öüäß'
  if special_chars > 0
    special_chars -= 1
  end
  special_chars.to_i
end

def get_array
  rawData = Hash.new{|h,k|h[k]=Hash.new}
  File.open 'data_complete.dat', 'r' do |file|
    file.each_line do |line|
      if line.to_s[0].chr === '#'
        next
      end
      data = line.split "\t"

      # category, product, default sell price
      category = (!data[8].to_s.empty? ? data[8].to_s : 'Tool')
      rawData[category.translate][data[1].translate] = data[3]
    end
  end
  rawData
end

class String
  MAX_LENGTH_STRING = 22
  MAX_LENGTH_COSTS = 7

  @@translation_container = Hash.new{|h,k|h[k]=Hash.new}

  def pad_string
    self.ljust MAX_LENGTH_STRING + get_count_special_chars(self)
    #self + ";"
  end

  def pad_costs
    self.ljust MAX_LENGTH_COSTS + 4
    #self + ";"
  end

  def load_translate
    unless @@translation_container.empty?
      return @@translation_container
    end

    File.open 'translation.dat', 'r' do |file|
      file.each_line do |line|
        data = line.split ':'
        @@translation_container[data[0].to_s.lstrip.rstrip] = data[1].to_s.lstrip.rstrip
      end
    end
    @@translation_container
  end

  def translate
    translation = load_translate[self.lstrip.rstrip].to_s
    if translation.to_s.empty?
      translation = self.lstrip.rstrip
    end
    translation.lstrip.rstrip
  end
end

get_array.sort.each do |category, data|
  data = data.sort_by { |k| k }
  puts
  puts
  #print "\n"
  cat_name = ":: #{category.to_s} ::"
  print cat_name.pad_string
  (1..10).each do |i| print i.to_s.pad_costs end
  puts
  puts separator
  #print "\n"


  data.each do |product,sp|
    print "#{product.pad_string}"
    (1..10).each do |i|
      price = ((i * (sp.to_i)) * 3.6).round.to_s
      print price.pad_costs
    end
    #print "\n"
    puts
    puts separator
  end
end

puts
puts "Time elapsed #{Time.now - beginning} seconds"
puts "Font: Courier New, Size: 8, remove bottom padding between lines"