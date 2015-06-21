module AttributesHelper
        def attr_options(attrs)
                attrs.reduce([]) do |options, attr|
                        options << [attr.name, attr.id]
                end
        end
end
