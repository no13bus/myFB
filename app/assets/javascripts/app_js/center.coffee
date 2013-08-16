#= require vender/ui/jquery.ui.widget
#= require vender/jquery.fileupload

$(document).on(
  dragleave: (e) ->
    e.preventDefault()
  drop: (e) ->
    e.preventDefault()
  dragenter: (e) ->
    e.preventDefault()
  dragover: (e) ->
    e.preventDefault()
)

UPLOADING = false
$(document).ready ->
  $('#insert .inner').on(
    drop: ->
      $(this).removeClass('active')
    dragleave: ->
      $(this).removeClass('active')
    dragover: ->
      $(this).addClass('active')
  )

  $(document).delegate('.copy-button', 'click', ->
    ele = $(this).parent()
    input = ele.children('input#link')
    input.select()
    if window.clipboardData
      window.clipboardData.setData('text', input.val())
      ele.parent().children('.help-block').text('已复制到剪切板')
    else
      ele.parent().children('.help-block').text('复制失败,请尝试手动复制.')
  )

  insertFile = (file, delay) ->
    ex = $('#example').clone()
    ex.attr('id', file.fs_id)
    ex.find('.thumbnail img').attr('src', file.url)
    ex.find('#link').val(file.url)
    ex.hide()
    ex.insertBefore('#end')
    setTimeout(->
      ex.fadeIn()
    , delay)

  removeFile = (images) ->
    images.remove()


  updateImages = ->
    $.ajax(
      url: $('.file-content').attr('src')
      success: (data) ->
        removeFile($('.file.image[id!="example"]'))

        n = 0
        for file in data.list
          insertFile(file, 200 * n++)
    )
  updateImages()

  # 初始化uploader
  upload = $('#insert #upload')
  upload_inner = $('#insert .inner')
  clicker = $('#upload-clicker')
  clicker.change ->
    upload.fileupload('send', {files:this.files})
  upload_inner.click ->
    clicker.click()
  upload.fileupload(
    autoUpload: false
    url: upload.attr('url')
    type: 'post'
    dataType: 'json'
    dropZone: upload_inner

    send: ->
      if UPLOADING
        return false
      else
        UPLOADING = true
    done: ->
      updateImages()
    always: ->
      UPLOADING = false

  )

#    upload.fileupload('send')
