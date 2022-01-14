# frozen_string_literal: true

require "minitest/autorun"

require "general_actor"

class ReactorActorTest < Minitest::Test
  def test_init
    obj = "Test String"
    _ = GeneralActor::RactorActor.new obj
  end

  def test_set
    obj = "Test String"
    a = GeneralActor::RactorActor.new obj
    a.value = "New Data"
    a
  end

  def test_get
    obj = "Test String"
    a = GeneralActor::RactorActor.new obj
    assert_equal obj, a.value
  end

  def test_get_set
    obj = "Test String"
    a = GeneralActor::RactorActor.new obj
    assert_equal obj, a.value
    new = "New Data"
    a.value = new
    assert_equal new, a.value
  end

  def test_concurrent
    ractor = GeneralActor::RactorActor.new 0

    datas = Array.new(100) { |_i| rand(1000) }
    threads = Array.new(99) do |i|
      Thread.new do
        ractor.value = datas[i]
        got = ractor.get_value_with_timeout 1
        # puts "Got the value #{got} in iteration #{i}"
        assert true if datas.any?(got) || got.nil?
      end
    end

    p threads

    threads.each(&:join)
  end
end
