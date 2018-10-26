// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery; // Bootstrap requires a global "$" object.
import "bootstrap";
import _ from 'lodash';
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

var started = false;
var start_time;

window.deleteTimeBlock = (button) => {
  let time_block_id = $(button).data('time-id');
    $.ajax(`${time_block_path}/${time_block_id}`, {
      method: "delete",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: "",
      success: (resp) => {
        window.location.reload();
    }
  });
}

window.updateTimeBlock = (button) => {
  let time_block_id = $(button).data('time-id');
  let task_id = $(button).data('task-id');
  let start_time = $('#new_start' + time_block_id).val() + ":00.000Z";
  let end_time = $('#new_end' + time_block_id).val() + ":00.000Z";
  let text = JSON.stringify({
    time_block: {
      start_time: start_time,
      end_time: end_time,
      task_id: task_id,
    },
  });
  $.ajax(`${time_block_path}/${time_block_id}`, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      window.location.reload();
    },
  });
}

window.changeUpdateTimeBlock = (button) => {
  let time_block_id = $(button).data('time-id');
  console.log("test");
  $('#new_start_reg' + time_block_id).hide();
  $('#new_end_reg' + time_block_id).hide();
  $('#new_start' + time_block_id).show();
  $('#new_end' + time_block_id).show();
  $('#update_button'+ time_block_id).show();
  $('#edit_button'+ time_block_id).hide();
}

$(function () {
  $('#time-block-create').click((ev) => {
    let task_id = $(ev.target).data('task-id');
    let start_time = $('#new_start').val() + ":00.000Z";
    let end_time = $('#new_end').val() + ":00.000Z";
    let text = JSON.stringify({
      time_block: {
        start_time: start_time,
        end_time: end_time,
        task_id: task_id,
      },
    });
    $.ajax(time_block_path, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
      success: (resp) => {
        window.location.reload();
      },
      error: (resp) => {
        console.log(resp);
      },
    });
  });

  $('#time-block-button').click((ev) => {
    let current_user_id = $(ev.target).data('user-id');
    let task_id = $(ev.target).data('task-id');
    let end_time;
    if(!started) {
      start_time = new Date();
      started = true;
      $('#time-block-button').text(`End time block`);
    }
    else {
      end_time = new Date();
      started = false;
      let text = JSON.stringify({
        time_block: {
          start_time: start_time,
          end_time: end_time,
          task_id: task_id,
        },
      });
      $.ajax(time_block_path, {
        method: "post",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: text,
        success: (resp) => {
          $('#time-block-button').text(`Start time block`);
          window.location.reload();
        },
      });
    }
  });
});
