require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'invoiceitem_repository'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_reader :customer_repository,
              :invoice_repository,
              :invoiceitem_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository,
              :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    @customer_repository     = CustomerRepository.new(self)
    @invoice_repository      = InvoiceRepository.new(self)
    @invoiceitem_repository  = InvoiceItemRepository.new(self)
    @item_repository         = ItemRepository.new(self)
    @merchant_repository     = MerchantRepository.new(self)
    @transaction_repository  = TransactionRepository.new(self)

    customer_repository.csv_loader
    invoice_repository.csv_loader
    invoiceitem_repository.csv_loader
    item_repository.csv_loader
    merchant_repository.csv_loader
    transaction_repository.csv_loader
  end

  def find_items_by_merchant_id(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant_id(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_successful_transactions_by_invoice_id(id)
    transaction_repository.find_all_successful_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice_id(id)
    invoiceitem_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_id(id)
    customer_repository.find_by_id(id)
  end

  def find_invoice_items_by_item_id(id)
    invoiceitem_repository.find_all_by_item_id(id)
  end

  def find_merchant_by_id(id)
    merchant_repository.find_by_id(id)
  end

  def find_invoice_by_id(id)
    invoice_repository.find_by_id(id)
  end

  def find_item_by_id(id)
    item_repository.find_by_id(id)
  end

end
