# Select [![Build Status](https://travis-ci.org/utkarshkukreti/select.ex.svg?branch=master)](https://travis-ci.org/utkarshkukreti/select.ex)

> An Elixir library to extract useful data from HTML documents, suitable for web scraping.

## Basic Usage

```elixir
iex(1)> nodes = Select.parse """
...(1)>   <html>
...(1)>     <head>
...(1)>       <title>A Title</title>
...(1)>     </head>
...(1)>     <body>
...(1)>       <h1>An H1</h1>
...(1)>       <!-- A Comment -->
...(1)>       <ul>
...(1)>         <li>A List Item</li>
...(1)>         <!-- Another Comment -->
...(1)>         <li>Another List Item</li>
...(1)>       </ul>
...(1)>       A Text Node
...(1)>     </body>
...(1)>   </html>
...(1)> """
[{"html", %{},
  [{"head", %{}, [{"title", %{}, ["A Title"]}]},
   {"body", %{},
    [{"h1", %{}, ["An H1"]}, {:comment, " A Comment "},
     {"ul", %{},
      [{"li", %{}, ["A List Item"]}, {:comment, " Another Comment "},
       {"li", %{}, ["Another List Item"]}]}, "\n      A Text Node\n    "]}]}]
iex(2)> nodes |> Select.find({:name, "li"})
[{"li", %{}, ["A List Item"]}, {"li", %{}, ["Another List Item"]}]
iex(3)> nodes |> Select.find(:text)
["A Title", "An H1", "A List Item", "Another List Item",
 "\n      A Text Node\n    "]
iex(4)> nodes |> Select.find(:comment)
[comment: " A Comment ", comment: " Another Comment "]
iex(5)> nodes |> Select.find({:or, {:name, "li"}, :text})
["A Title", "An H1", {"li", %{}, ["A List Item"]}, "A List Item",
 {"li", %{}, ["Another List Item"]}, "Another List Item",
 "\n      A Text Node\n    "]
```

For more available matchers, check out the
[tests](https://github.com/utkarshkukreti/select.ex/blob/master/test/select_test.exs).

## License

MIT
