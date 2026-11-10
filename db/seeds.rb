# 初期データ（実在のカフェ5件とタグ）
# 実行: bundle exec rails db:seed

cafes = [
  {
    name: "Cafe Naka蔵",
    address: "島根県出雲市今市町中町689",
    latitude: 35.36422461,
    longitude: 132.75666656,
    tell_number: "0853-31-5880",
    parking: true
  },
  {
    name: "Cafe LINQ Takasegawa",
    address: "島根県出雲市今市町733",
    latitude: 35.36518052,
    longitude: 132.75486286,
    tell_number: "0853-25-7945",
    parking: true
  },
  {
    name: "Minklu",
    address: "島根県出雲市高岡町506-1",
    latitude: 35.384604,
    longitude: 132.754923,
    tell_number: "0853-25-8160",
    parking: true,
    credit_card: true,
    cashless: true
  },
  {
    name: "エミル（Cafe Emil）",
    address: "島根県出雲市大津町2077-8",
    latitude: 35.36551446,
    longitude: 132.76887811,
    tell_number: "070-8907-6291",
    parking: true
  },
  {
    name: "koharu",
    address: "島根県出雲市大社町杵築南1353-15",
    latitude: 35.39314428,
    longitude: 132.68685655,
    tell_number: "0853-77-8094",
    parking: true
  }
]

cafes.each do |attributes|
  cafe = Cafe.find_or_initialize_by(name: attributes[:name])
  cafe.assign_attributes(attributes)
  cafe.save!
end

%w[抹茶 スイーツ コーヒー 和カフェ テイクアウト モーニング 一人でも デート].each do |name|
  Tag.find_or_create_by!(name: name)
end

puts "cafes: #{Cafe.count} / tags: #{Tag.count}"