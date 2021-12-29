defmodule BlogAppWeb.PostControllerTest do
  use BlogAppWeb.ConnCase
  # use ExUnit.CaseTemplate
  use ExUnit.Case

  alias BlogApp.Comments.Comment
  # alias BlogApp.Posts.Post
  import BlogApp.PostsFixtures
  # import Ecto.Enum
  # import BlogApp.CommentsFixtures

  @create_attrs %{body: "some body", title: "some title", content: "some content", name: "some name", post_id: "id"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil, content: nil, name: nil, post_id: nil}
  @valid_attrs %{content: "some content", name: "some name", post_id: "some id"}

  # @create_attrs %{content: "some comment", name: "some name"}
  # @update_attrs %{content: "some updated comment", name: "some updated name"}
  # @invalid_attrs %{content: nil, name: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      # IO.inspect(conn)
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  #  describe "add comment" do
  #   setup [:create_post]

  #   test "redirects to show when comment is vaild", %{conn: conn, post: post} do
  #     # IO.inspect(conn)
  #     conn = post(conn, Routes.post_path(conn, :create), %{comment: @create_attrs, post_id: post["id"]})

  #     assert %{post_id: post_id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.post_path(conn, :show, post_id)

  #     conn = get(conn, Routes.post_path(conn, :show, post_id))
  #     assert html_response(conn, 200) =~ "show comment"
  #   end

  #   test "renders errors when comment is invalid", %{conn: conn, post: post} do
  #     conn = post(conn, Routes.post_path(conn, :create), %{comment: @invalid_attrs, post_id: post["id"]})
  #     assert html_response(conn, 200) =~ "new comment"
  #   end
  #  end

  describe "add comment" do
    test "changeset with valid attributes" do
      changeset = Comment.changeset(%Comment{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Comment.changeset(%Comment{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end

  # defp create_comment(_) do
  #   comment = comment_fixture(comment)
  #   %{comment: comment}
  # end
end
