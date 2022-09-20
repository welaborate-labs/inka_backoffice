class AddXmlAndPdfUrlsErrorMessageAndReferenceToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :xml_url, :string
    add_column :bills, :pdf_url, :string
    add_column :bills, :error_message, :string, array: true, default: []
    add_column :bills, :reference, :string
  end
end
