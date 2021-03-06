require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'
require_relative 'test_helper'
require_relative '../lib/sales_engine'


class MerchantRepositoryTest < Minitest::Test
  attr_reader :data1,
              :data2,
              :data3,
              :merchant_repository

  def setup
    @data1 =  {
                id: "1",
                name: "Schroeder-Jerde",
                created_at: "2012-03-27 14:53:59 UTC",
                updated_at: "2012-03-27 14:53:59 UTC"
              }

    @data2 =  {
                id: "2",
                name: "Sear",
                created_at: "2013-03-27 14:53:59 UTC",
                updated_at: "2013-03-27 14:53:59 UTC"
              }

    @data3 =  {
                id: "3",
                name: "McDonalds",
                created_at: "2013-03-27 14:53:59 UTC",
                updated_at: "2013-03-27 14:53:59 UTC"
              }
  end

  def load_test_data
    @merchant_repository = MerchantRepository.new(nil)
    merchant_repository << data1
    merchant_repository << data2
    merchant_repository << data3
  end

  def test_it_knows_its_parent
    mr = MerchantRepository.new(nil)
    mr << data1
    assert_equal mr, mr.merchants.first.repository
  end

  def test_it_starts_empty
    merchant_repository = MerchantRepository.new(nil)
    assert merchant_repository.merchants.empty?
  end

  def test_it_has_merchants
    load_test_data
    refute merchant_repository.merchants.empty?
  end

  def test_it_has_three_merchants
    load_test_data
    assert_equal 3, merchant_repository.merchants.size
  end

  def test_it_can_access_individual_merchants
    load_test_data
    assert_equal "McDonalds", merchant_repository.merchants[2].name
  end

  def test_all_method_returns_all_merchants
    load_test_data
    refute merchant_repository.all.empty?
    assert_equal 3, merchant_repository.all.size
    assert_equal merchant_repository.merchants, merchant_repository.all
  end

  def test_all_returns_array
    load_test_data
    assert merchant_repository.all.is_a?(Array)
  end

  def test_random_returns_one_merchant
    load_test_data
    assert merchant_repository.random.is_a?(Merchant)
  end

  def test_random_does_not_return_array_of_merchants
    load_test_data
    refute merchant_repository.random.is_a?(Array)
  end

  def test_find_by_id
    load_test_data
    result = merchant_repository.find_by_id(2)
    assert_equal "Sear", result.name
  end

  def test_find_all_by_id
    load_test_data
    result = merchant_repository.find_all_by_id(2)
    assert_equal "Sear", result.first.name
  end

  def test_find_by_name
    load_test_data
    result = merchant_repository.find_by_name("Sear")
    assert_equal "2013-03-27", result.created_at
  end

  def test_find_all_by_name
    load_test_data
    result = merchant_repository.find_all_by_name("Sear")
    assert_equal "2013-03-27", result.first.created_at
  end

  def test_find_by_created_at
    load_test_data
    result = merchant_repository.find_by_created_at("2013-03-27")
    assert_equal "Sear", result.name
  end

  def test_find_all_by_created_at
    load_test_data
    result = merchant_repository.find_all_by_created_at("2013-03-27")
    assert_equal "McDonalds", result.last.name
  end

  def test_find_by_updated_at
    load_test_data
    result = merchant_repository.find_by_updated_at("2013-03-27")
    assert_equal "Sear", result.name
  end

  def test_find_all_by_updated_at
    load_test_data
    result = merchant_repository.find_all_by_updated_at("2013-03-27")
    assert_equal "McDonalds", result.last.name
  end

  def test_it_calls_se_to_find_items_by_merchant_id
    parent = Minitest::Mock.new
    mr = MerchantRepository.new(parent)
    mr << data1
    mr << data2
    mr << data3
    parent.expect(:find_items_by_merchant_id, nil, [1])
    mr.find_items(mr.merchants.first.id)
    parent.verify
  end

  def test_it_calls_se_to_find_invoices_by_merchant_id
    parent = Minitest::Mock.new
    mr = MerchantRepository.new(parent)
    mr << data1
    mr << data2
    mr << data3
    parent.expect(:find_invoices_by_merchant_id, nil, [1])
    mr.find_invoices(mr.merchants.first.id)
    parent.verify
  end

  def test_most_revenue
    se = SalesEngine.new(nil)
    se.startup
    result = se.merchant_repository.most_revenue(3)
    assert 3, result.size
    assert result.is_a?(Array)
    assert result[0].is_a?(Merchant)
  end

  def test_most_items
    se = SalesEngine.new(nil)
    se.startup
    result = se.merchant_repository.most_items(3)
    assert 3, result.size
    assert result.is_a?(Array)
    assert result[0].is_a?(Merchant)
  end

  def test_all_merchant_revenue_for_date
    se = SalesEngine.new(nil)
    se.startup
    assert_equal BigDecimal.new("1908368.05"), se.merchant_repository.revenue("2012-03-27")
  end

end
