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
      if @banks.nil?
        @banks = {}
        json = JSON.load(File.read(ZenginCode::DATA_DIR.join('banks.json')))
        json.values.each do |bank_data|
          new(bank_data)
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
    self.class.send(:[]=, code, self)
  end

  attr_reader :code, :name, :kana, :hira, :roma

  def branches
    if @branches.nil?
      @branches = {}
      json = JSON.load(File.read(ZenginCode::DATA_DIR.join("branches/#{code}.json")))
      json.values.each do |branch_data|
        branch = ZenginCode::Branch.new(self, branch_data)
        @branches[branch.code] = branch
      end
    end
    @branches
  end
end
