json.array! @games do |game|
  json.id         game.id
  json.name       game.name
  json.updated_at game.updated_at
end 