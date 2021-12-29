defmodule BlogAppWeb.PageControllerTest do
  use BlogAppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    refute html_response(conn, 200) =~ "Welcome to Elixir's Blogs!!!"
  end
end
