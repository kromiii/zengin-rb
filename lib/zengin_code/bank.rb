require 'zengin_code'

class ZenginCode::Bank


  class << self
    def [](code)
      all[code]
    end

    def []=(code, bank)
      @banks ||= {}
      @banks[code] = bank
    end

    def all
      return @banks if @data_loaded

      @banks_mutex ||= Mutex.new
      @banks_mutex.synchronize do
        unless @data_loaded
          @banks ||= {}
          json = JSON.load(File.read(ZenginCode::DATA_DIR.join('banks.json')))
          json.values.each do |bank_data|
            new(bank_data)
          end
          @data_loaded = true
        end
      end
      @banks
    end
  end

  def initialize(options = {})
    @code = options['code']
    @name = options['name']
    @kana = options['kana']
    @hira = options['hira']
    @roma = options['roma']
    @branches_mutex = Mutex.new
    self.class.send(:[]=, code, self)
  end

  attr_reader :code, :name, :kana, :hira, :roma

  def branches
    return @branches if @branches

    @branches_mutex.synchronize do
      if @branches.nil?
        @branches = {}
        json = JSON.load(File.read(ZenginCode::DATA_DIR.join("branches/#{code}.json")))
        json.values.each do |branch_data|
          branch = ZenginCode::Branch.new(self, branch_data)
          @branches[branch.code] = branch
        end
      end
    end
    @branches
  end
end
