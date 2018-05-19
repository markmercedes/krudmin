class DocsController < Krudmin::CustomController
  REDCARPET_CONFIG = {
    fenced_code_blocks: true,
    autolink: true,
    tables: true
  }.freeze

  helper_method :active_doc_file

  def index
    @md_content = render_markdown(active_doc_file)
  end

  def show
    @md_content = render_markdown("docs/#{active_doc_file}")

    render "index"
  end

  def active_doc_file
    params.fetch(:id, "README")
  end

  private

  def render_markdown(file)
    text = File.read(Rails.root + "../../#{file}.md")
    renderer = Redcarpet::Render::HTML
    markdown = Redcarpet::Markdown.new(renderer, REDCARPET_CONFIG)
    markdown.render(text).html_safe
  end
end
