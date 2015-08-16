defmodule Select do
  def parse(string) do
    :mochiweb_html.parse(string)
  end

  def matches?(node, func) when is_function(func, 1) do
    func.(node)
  end
  def matches?({name, _, _}, {:name, name}), do: true
  def matches?(_, {:name, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr}) do
    attrs |> Enum.any?(fn {k, _} -> k == attr end)
  end
  def matches?(_, {:attr, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr, value}) do
    attrs |> Enum.any?(fn {k, v} -> k == attr and v == value end)
  end
  def matches?(_, {:attr, _, _}), do: false
  def matches?(node, {:and, a, b}), do: matches?(node, a) and matches?(node, b)
  def matches?(node, {:or, a, b}), do: matches?(node, a) or matches?(node, b)
  def matches?(node, {:not, a}), do: not matches?(node, a)
  def matches?({_, attrs, _}, {:class, class}) do
    case Enum.find(attrs, fn {k, _} -> k == "class" end) do
      nil -> false
      {"class", classes} -> classes |> String.split |> Enum.any?(&(&1 == class))
    end
  end
  def matches?(_, {:class, _}), do: false
  def matches?({_, _, _}, :element), do: true
  def matches?(_, :element), do: false
  def matches?({_, _, _}, :text), do: false
  def matches?({:comment, _}, :text), do: false
  def matches?(_, :text), do: true
  def matches?({:comment, _}, :comment), do: true
  def matches?(_, :comment), do: false

  def find(nodes, [_|_] = matchers) do
    Enum.reduce matchers, nodes, fn matcher, nodes ->
      find(nodes, matcher)
    end
  end
  def find(nodes, matcher) when is_list(nodes) do
    Enum.flat_map(nodes, &find(&1, matcher))
  end
  def find({_, _, children} = node, matcher) do
    if(matches?(node, matcher), do: [node], else: []) ++ find(children, matcher)
  end
  def find(node, matcher) do
    if(matches?(node, matcher), do: [node], else: [])
  end

  def text({_, _, children}), do: Enum.map_join(children, &text/1)
  def text({:comment, _}), do: ""
  def text(string), do: string

  def html(nodes) when is_list(nodes), do: Enum.map_join(nodes, &html/1)
  def html({_, _, _} = node), do: :mochiweb_html.to_html(node)
  def html({:comment, _} = node), do: :mochiweb_html.to_html(node)
  def html(string), do: string
end
