window.BulkEditOfMeasuresSaveActions =

  sendSaveRequest: ->
    console.log '     current_batch: ' + window.__sb_current_batch

    bottom_limit = (window.__sb_current_batch - 1) * window.__sb_per_page
    top_limit = bottom_limit + window.__sb_per_page
    final_batch = false

    if window.__sb_current_batch == window.__sb_total_pages
      top_limit = window.__sb_total_count
      final_batch = true

    console.log ''
    console.log '     bottom_limit: ' + bottom_limit
    console.log ''
    console.log '     top_limit: ' + top_limit
    console.log ''
    console.log '     final_batch: ' + final_batch
    console.log ''

    data = {
      final_batch: final_batch
      measures: window.__sb_measures_collection.splice(bottom_limit, top_limit)
    }

    ops = 'page=' + window.__sb_current_batch + '&bottom_limit=' + bottom_limit + '&top_limit=' + top_limit

    $.ajax
      url: '/measures/bulks/' + window.__workbasket_id.toString() + '.json?' + ops
      data: JSON.stringify(data)
      type: 'PUT'
      processData: false
      contentType: 'application/json'
      success: (result) ->

        console.log ''
        console.log '         SUCCESS for BATCH: ' + window.__sb_current_batch
        console.log ''

        window.__sb_current_batch = window.__sb_current_batch + 1
        if window.__sb_current_batch <= window.__sb_total_pages
          BulkEditOfMeasuresSaveActions.sendSaveRequest()

        return false

    return false
