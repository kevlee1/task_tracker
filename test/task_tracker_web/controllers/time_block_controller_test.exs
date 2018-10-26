defmodule TaskTrackerWeb.TimeBlockControllerTest do
  use TaskTrackerWeb.ConnCase

  alias TaskTracker.TimeBlocks

  @create_attrs %{endTime: "2010-04-17 14:00:00.000000Z", startTime: "2010-04-17 14:00:00.000000Z"}
  @update_attrs %{endTime: "2011-05-18 15:01:01.000000Z", startTime: "2011-05-18 15:01:01.000000Z"}
  @invalid_attrs %{endTime: nil, startTime: nil}

  def fixture(:time_block) do
    {:ok, time_block} = TimeBlocks.create_time_block(@create_attrs)
    time_block
  end

  describe "index" do
    test "lists all time_block", %{conn: conn} do
      conn = get(conn, Routes.time_block_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Time block"
    end
  end

  describe "new time_block" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.time_block_path(conn, :new))
      assert html_response(conn, 200) =~ "New Time block"
    end
  end

  describe "create time_block" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.time_block_path(conn, :create), time_block: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.time_block_path(conn, :show, id)

      conn = get(conn, Routes.time_block_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Time block"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.time_block_path(conn, :create), time_block: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Time block"
    end
  end

  describe "edit time_block" do
    setup [:create_time_block]

    test "renders form for editing chosen time_block", %{conn: conn, time_block: time_block} do
      conn = get(conn, Routes.time_block_path(conn, :edit, time_block))
      assert html_response(conn, 200) =~ "Edit Time block"
    end
  end

  describe "update time_block" do
    setup [:create_time_block]

    test "redirects when data is valid", %{conn: conn, time_block: time_block} do
      conn = put(conn, Routes.time_block_path(conn, :update, time_block), time_block: @update_attrs)
      assert redirected_to(conn) == Routes.time_block_path(conn, :show, time_block)

      conn = get(conn, Routes.time_block_path(conn, :show, time_block))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, time_block: time_block} do
      conn = put(conn, Routes.time_block_path(conn, :update, time_block), time_block: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Time block"
    end
  end

  describe "delete time_block" do
    setup [:create_time_block]

    test "deletes chosen time_block", %{conn: conn, time_block: time_block} do
      conn = delete(conn, Routes.time_block_path(conn, :delete, time_block))
      assert redirected_to(conn) == Routes.time_block_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.time_block_path(conn, :show, time_block))
      end
    end
  end

  defp create_time_block(_) do
    time_block = fixture(:time_block)
    {:ok, time_block: time_block}
  end
end
