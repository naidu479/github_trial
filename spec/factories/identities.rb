FactoryGirl.define do
  factory :identity do
    user
    provider "facebook" || "google"
    accesstoken "CAAFVE5QDB2UBADSBILA7ygypqFYDEG3QxlVNEbnnoyTKEUqBjRMbZBMHhd5SCfNS2IoJy7zvZAryiiwYBDc9uzy34ufSZCe5WSwDHeYHSJdRi0MasHa9LWFCbFMezhWNXFldyXml7lZAZCe0uIYF7VeXeL4QT3ZAFEZAL4q4GLI7tYw6f7wGnYtnNmWO7pcne82XdX81ZAoOjwZDZD"
    uid "10204937947520715"
  end
end

