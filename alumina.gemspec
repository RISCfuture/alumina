# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "alumina"
  s.version = File.read(File.expand_path("VERSION", __dir__)).strip

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Morgan"]
  s.email = "git@timothymorgan.info"
  s.summary = "[DEPRECATED] Ruby parser for various chemistry-related file formats"
  s.description = "This gem parses HyperChem's .HIN files, PDB files, and in the future others, converting them to Ruby objects for easy manipulation"
  s.homepage = "http://github.com/RISCfuture/alumina"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]

  s.files = Dir["lib/**/*.rb"] + Dir["data/**/*"] + %w[LICENSE README.textile VERSION Rakefile]

  s.post_install_message = <<~MSG

    ⚠️  DEPRECATED: alumina is no longer maintained.

    This gem parsed HyperChem/PDB chemistry files; consider modern alternatives like the `bio` gem for general bioinformatics file parsing.

    This is the final release. No further updates are planned.

  MSG
end
