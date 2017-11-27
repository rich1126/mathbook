<content>
  <style>
    #contentSectionText{
      white-space: pre-wrap;
    }
  </style>
  <section class="section">
    <div id="contentContainer" class="container">
      <h5 class="title">Content</h5>
      <h6 class="subtitle">The content explains the 'What', 'Why' and 'How'</h6>
  <div class="field">
    <div class="control">
      <input type="text" id="contentTitle" class="input mathContent {is-danger: isTitleEmpty}" placeholder="Section Title ie) Understanding Factoring"/>
       <p show={ isTitleEmpty } class="help is-danger">Title can't be empty</p>
    </div>
  </div>
  <div class="field">
    <div class="control">
      <textarea id="contentSection" class="textarea mathContent {is-danger: isContentEmpty}" placeholder="section content..."></textarea>
       <p show={ isContentEmpty } class="help is-danger">The content section can't be empty</p>
    </div>
    <br/>
    <div class="control">
    <label>Preview</label>
      <div class="box">
        <p id='contentSectionText' class="previewText"></p>
      </div>
    </div>
  </div>
  <div class="control">
    <a class="button is-info" onclick={ saveSection }>Add Section</a>
  </div>
  <br/>
    <div id="sectionList"></div>
    </div>
  </section>
  
  <script>
    var that = this
    this.contentMap = {}
    this.isTitleEmpty = false
    this.isContentEmpty = false
    this.contentObservable = riot.observable()

  this.on('mount', function() {
    that.initSortable()
    
    this.contentObservable.on('createdContentSection', function(contentId, contentObj) {
      that.contentMap[contentId] = contentObj
    })
    
    this.contentObservable.on('deletedContentSection', function(contentId) {
      delete that.contentMap[contentId]
    })

    $('#contentSection').on('input', function(e) {
      var contentVal = $('#contentSection').val()
      $('#contentSectionText').html(contentVal)
      renderMathInElement(document.getElementById('contentSectionText'))
    });

  })

  initSortable(){
    var sectionList = document.getElementById('sectionList')
    Sortable.create(sectionList, { 
      handle: '.moveHandle',
      onUpdate: function(e){
        console.log('onUpdate triggered', e)
        console.log('old index', e.oldIndex)
        console.log('new index', e.newIndex)
        that.contentObservable.trigger('contentOrderUpdate', e.oldIndex, e.newIndex)

      } });
  }

  saveSection(){
    var sectionNumber = this.uniqueId()
    var sectionId = 'sectionBox_'+sectionNumber

    var sectionTitle = $('#contentTitle').val()
    var sectionText = $('#contentSection').val()

    this.isTitleEmpty = this.isTextEmpty(sectionTitle)
    this.isContentEmpty = this.isTextEmpty(sectionText)
    if (this.isTitleEmpty || this.isContentEmpty){
      return
    }
    this.generateSection(sectionId, sectionTitle, sectionText)
  }

  generateSection(sectionId, sectionTitle, sectionText){
    const contentIndex = $('content-section').length
    console.log('contentIndex', contentIndex)
    $('#sectionList').append('<content-section ref="'+sectionId+'" id="'+sectionId+'"></content-section>')
    riot.mount('#'+sectionId, 'content-section', { contentObservable: this.contentObservable, contentIndex: contentIndex, sectionTitle: sectionTitle, sectionText: sectionText })[0]
    this.cleanupFields()
    this.update()
  }

  cleanupFields(){
    $('#contentTitle').val('')
    $('#contentSection').val('')
    $('#contentSectionText').html('')

  }

  isTextEmpty(text){
    return ($.trim(text) === '')
  }

  uniqueId() {
    return Math.random().toString(36).substr(2, 10);
  };

  get(){
    const contentList = []
    for (var contentId in this.contentMap){
      var content = this.contentMap[contentId].get()
      contentList[content.contentIndex] = content
    }
    return contentList
  }

  set(data){
    console.log(data)
    if(Array.isArray(data)){
      for(var i in data){
        console.log('set::section', data[i])
        const sectionId = data[i].id
        const sectionTitle = data[i].title
        const sectionText = data[i].text
        this.generateSection(sectionId, sectionTitle, sectionText)
      }
    }
  }

  </script>
</content>