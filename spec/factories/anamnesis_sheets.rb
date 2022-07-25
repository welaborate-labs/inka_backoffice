FactoryBot.define do
  factory :anamnesis_sheet do
    customer
    recent_cirurgy { true }
    recent_cirurgy_details { "some recent_cirurgy_details text" }
    cronic_diseases { true }
    cronic_diseases_details { "some cronic_diseases_details text" }
    pregnant { true }
    lactating { true }
    medicine_usage { "some medicine_usage text" }
    skin_type { %w[Oleosa Mista Seca Normal].sample }
    skin_acne { false }
    skin_scars { false }
    skin_spots { false }
    skin_normal { true }
    psoriasis { true }
    dandruff { true }
    skin_peeling { true }
    skin_peeling_details { "some skin_peeling_details text" }
    cosmetic_allergies { true }
    cosmetic_allergies_details { "some cosmetic_allergies_details text" }
    chemical_allergies { true }
    chemical_allergies_details { "some chemical_allergies_details text" }
    food_allergies { true }
    food_allergies_details { "some food_allergies_details text" }
    alcohol { true }
    tobacco { true }
    coffee { true }
    other_drugs { true }
    other_drugs_details { "some other_drugs_details text" }
    sleep_details { "some sleep_details text" }
    has_period { true }
    period_details { "some period_details text" }
    had_therapy_before { true }
    therapy_details { "some therapy_details text" }
    current_main_concern { "some current_main_concern text" }
    change_motivations { "some change_motivations text" }
    emotion { "some emotion text" }
    confidentiality_aggreement { true }
    image_usage_aggreement { true }
    responsibility_aggreement { true }
  end
end
