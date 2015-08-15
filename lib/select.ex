defmodule Select do
  def parse(string) do
    :mochiweb_html.parse(string)
  end

  def matches?(node, func) when is_function(func, 1) do
    func.(node)
  end
end
