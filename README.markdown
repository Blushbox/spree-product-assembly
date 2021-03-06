# Product Assembly

Create a product which is composed of other products.

## About this fork

This fork introduces the notion of assembly variants. For example, an assembly named "Bundle 1" may have variants:

- small
- medium
- large

and contain two parts:

- t-shirt
- hat

If the t-shirt has three variants (small / medium / large), and the hat has no variants (ie one-size-fits-all), then "Bundle 1" can be configured as follows:

- Small (assembly variant): contains T-shirt small variant (part variant) + Hat (no variant)
- Medium (assembly variant): contains T-shirt medium variant (part variant) + Hat (no variant)
- Large (assembly variant): contains T-shirt large variant (part variant) + Hat (no variant)

Note: assemblies with no variants are also supported.

## Todo

Make all specs pass

Currently, there is no rake task available to migrate an existing database from original gem to this fork.  If you have an existing database and would like to switch from the original gem to this fork, you'd have to manually update existing spree_assemblies_parts.assembly_id values to point to spree_variants.id instead of spree_products.id (whereas the variant in this case would be the master for that product) -- or contribute a rake task ;)

## Caveats

- Changing an assembly from having no variants to having variants (and vice-versa) once parts have already been associated might trigger a space-time discontinuity.
- If a part is to be associated to all variants, there is currently no shortcut to do so (ie you will have to manually associate the part to each variant).

## Installation

Add the following line to your Gemfile

    gem "spree_product_assembly", :git => "https://github.com/Blushbox/spree-product-assembly"

Run bundle install as well as the extension install command to copy and run migrations and
append spree_product_assembly to your js manifest file

    bundle install
    rails g spree_product_assembly:install

_Use 1-3-stable branch for Spree 1.3.x compatibility_

_In case you're upgrading from 1-3-stable of this extension you might want to run a
rake task which assigns a line item to your previous inventory units from bundle
products. That is so you have a better view on the current backend UI and avoid
exceptions. No need to run this task if you're not upgrading from product assembly
1-3-stable_

    rake spree_product_assembly:upgrade

# Use

This extension adds a `can_be_part` boolean attribute to the spree_products_table.
You'll need to check that flag on the backend product form so that it can be
<<<<<<< HEAD
be found by the parts search form on the bundle product.

Once a product is included as a _part_ of another it will be included on the order
shipment and inventory units for each part will be created accordingly.

Inventory is tracked at the part level.

# Run tests

See .travis.yml for Travis CI config

Otherwise, to run specs manually, do:

    bundle exec rake test_app
    bundle exec rspec spec

