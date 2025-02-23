# frozen_string_literal: true
module RailsCom::AssetsHelper

  # Assets path: app/assets/javascripts/controllers
  # Packs Path: app/javascript/packs/javascripts
  def origin_js_load(**options)
    ext = ['.js', '.js.erb'] + Array(options.delete(:ext))
    suffix = options.delete(:suffix)

    asset_filename = "controllers/#{@_rendered_path}"
    pack_filename = "javascripts/#{@_rendered_path}"

    if suffix
      asset_filename = [asset_filename, '-', suffix].join
      pack_filename = [pack_filename, '-', suffix].join
    end

    asset_paths = assets_load_path(asset_filename, relative_path: 'app/assets/javascripts', ext: ext)
    pack_paths = assets_load_path(pack_filename, relative_path: 'app/javascript/packs', ext: ext)

    r = []
    ar = []
    if asset_paths.any? { |path| File.exist?(path) }
      r << javascript_include_tag(asset_filename, options)
      ar << javascript_path(asset_filename)
    end

    if pack_paths.any? { |path| File.exist?(path) }
      r << javascript_pack_tag(pack_filename, options)
      ar << asset_pack_path(pack_filename + '.js')
    end

    [r.join("\n    ").html_safe, ar]
  end

  def js_load(**options)
    r, _ = origin_js_load(options)
    r
  end

  def remote_js_load(**options)
    _, r = origin_js_load(options)
    r
  end

  def js_ready(**options)
    js_load(suffix: 'ready', **options)
  end

  # Assets path: app/assets/stylesheets/controllers
  # Packs Path: app/javascript/packs/stylesheets
  def css_load(**options)
    ext = ['.css', '.css.erb'] + Array(options.delete(:ext))
    suffix = options.delete(:suffix)

    asset_filename = "controllers/#{@_rendered_path}"
    pack_filename = "stylesheets/#{@_rendered_path}"

    if suffix
      asset_filename = [asset_filename, '-', suffix].join
      pack_filename = [pack_filename, '-', suffix].join
    end

    asset_paths = assets_load_path(asset_filename, relative_path: 'app/assets/stylesheets', ext: ext)
    pack_paths = assets_load_path(pack_filename, relative_path: 'app/javascript/packs', ext: ext)

    r = []
    if asset_paths.any? { |path| File.exist?(path) }
      r << stylesheet_link_tag(asset_filename, options)
    end

    if pack_paths.any? { |path| File.exist?(path) }

      begin
        rs = stylesheet_pack_tag(pack_filename, options)
      rescue
        rs = nil
      end

      if rs.is_a?(String)
        r << rs
      else
        r << javascript_pack_tag(pack_filename, options)
      end
    end

    r.join("\n    ").html_safe
  end

  private
  def assets_load_path(filename, relative_path:, ext:)
    paths = []

    file_path = Pathname.new(relative_path).join filename
    rails_path = Rails.root.join file_path
    ext.each do |name|
      paths << rails_path.to_s + name
    end
    if @_rendered_engine
      engine_path = @_rendered_engine.join file_path
      ext.each do |name|
        paths << engine_path.to_s + name
      end
    end

    paths
  end

end
