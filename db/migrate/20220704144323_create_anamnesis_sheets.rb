class CreateAnamnesisSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :anamnesis_sheets do |t|
      t.boolean :recent_cirurgy
      t.text :recent_cirurgy_details
      t.boolean :cronic_diseases
      t.text :cronic_diseases_details
      t.boolean :pregnant
      t.boolean :lactating
      t.text :medicine_usage
      t.string :skin_type
      t.boolean :skin_acne
      t.boolean :skin_scars
      t.boolean :skin_spots
      t.boolean :skin_normal
      t.boolean :psoriasis
      t.boolean :dandruff
      t.boolean :skin_peeling
      t.text :skin_peeling_details
      t.boolean :cosmetic_allergies
      t.text :cosmetic_allergies_details
      t.boolean :chemical_allergies
      t.text :chemical_allergies_details
      t.boolean :food_allergies
      t.text :food_allergies_details
      t.boolean :alcohol
      t.boolean :tobacco
      t.boolean :coffee
      t.boolean :other_drugs
      t.text :other_drugs_details
      t.text :sleep_details
      t.boolean :has_period
      t.text :period_details
      t.boolean :had_therapy_before
      t.text :therapy_details
      t.text :current_main_concern
      t.text :change_motivations
      t.text :emotion
      t.boolean :confidentiality_aggreement
      t.boolean :image_usage_aggreement
      t.boolean :responsibility_aggreement

      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
