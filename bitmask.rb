require 'minitest/autorun'
require 'pry'

class BitMask
  CONFIG = {
    resource: 0b0001,
    comment: 0b0010,
    post: 0b0100,
    reply: 0b1000
  }

  def initialize(settings)
    @setting = settings
  end

  def get_all_state
    state = {}
    CONFIG.each do |k, mask|
      state[k] = (@setting & mask) == mask
    end
    state
  end

  def get_state(type)
    @setting & CONFIG[type] == CONFIG[type]
  end

  def switch(type)
    @setting ^= CONFIG[type]
  end

  def turn_on(type)
    @setting |= CONFIG[type]
  end

  def turn_off(type)
    @setting &= ~CONFIG[type]
  end
end

class TestBitMask < MiniTest::Test
  def setup
    @bit_mask = BitMask.new(0b1011)
  end

  def test_get_init_settings
    assert_equal(
      {
        resource: true,
        comment: true,
        post: false,
        reply: true
      },
      @bit_mask.get_all_state
    )
  end

  def test_get_specific_settings
    assert_equal(true, @bit_mask.get_state(:resource))
    assert_equal(false, @bit_mask.get_state(:post))
  end

  def test_set_settings
    @bit_mask.turn_on(:post)
    assert_equal(true, @bit_mask.get_state(:post))
    @bit_mask.turn_off(:post)
    assert_equal(false, @bit_mask.get_state(:post))
    @bit_mask.switch(:post)
    assert_equal(true, @bit_mask.get_state(:post))
    @bit_mask.switch(:post)
    assert_equal(false, @bit_mask.get_state(:post))
  end
end
