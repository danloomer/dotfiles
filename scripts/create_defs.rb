def create_defs
  shop = Shop.first
  shop_id = shop.id
  types = MetafieldTypes::Types.metafield_definition_types.values.map { |x| x.name }
  max = 100

  owner_types = [
    Metafield::OwnerType::Product,
    Metafield::OwnerType::ProductVariant,
  ].map { |x| x.serialize }

  owner_types.each do |owner_type|
    max.times do |count|
      type = types[count % types.size]
      definition = MetafieldDefinition.new(
        namespace: "my_fields",
        key: "#{type}_#{count}",
        owner_type: owner_type,
        shop_id: shop_id,
        name: "#{type.titleize} #{count}",
        type_name: type,
        pinned_position: count <= 18 ? count : 0
      )
      unless definition.save
        puts "failed to create #{owner_type} definition of type #{type}"
      end
    end
  end
end

def create_metafields
  shop = Shop.first
  shop_id = shop.id
  max = 60

  owner_type_map = {
    Metafield::OwnerType::Product => Product,
    Metafield::OwnerType::ProductVariant => ProductVariant
  }

  owner_type_map.each do |owner_type, owner_model|
    owner_id = owner_model.first.id
    max.times do |count|
      metafield_record = Metafield.new(
        namespace: "my_fields",
        key: "field_#{count}",
        value: "value #{count}",
        owner_type: owner_type.serialize,
        owner_id: owner_id,
        shop_id: shop_id,
        type: "single_line_text_field",
      )
      unless metafield_record.save
        puts "failed to create #{owner_type} metafield for owner #{owner_id}"
      end
    end
  end
end
