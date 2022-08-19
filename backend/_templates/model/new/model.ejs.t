---
to: lib/models/<%= name %>.rb
---
class Sniphub
  class <%= h.inflection.capitalize(name) %> < Sequel::Model(:<%= h.inflection.pluralize(name) %>)
    plugin :timestamps, update_on_create: true
    plugin :uuid
  end
end
