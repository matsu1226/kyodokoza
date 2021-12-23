//https://www.webya-wagai.jp/articles/1
import Sortable from 'sortablejs';
export default() => {

  document.addEventListener("turbolinks:load",() => {
    $(function() {
      const el = document.getElementById('category_list');
      new Sortable(el, {
        handle: "#category_item",   // Drag handle selector within list items
        axis: "y",                  
        animation: "100",           // ms, animation speed moving items when sorting, `0` — without animation       
        onUpdate: function(e) {     // ソートされリスト内が新たに更新された時
          return $.ajax({
            url: `/api/category/positions/${e.oldIndex}`,
            type: 'patch',
            data: {
              from: e.oldIndex,   // constrollerにて params[:from]で取り出し
              to: e.newIndex      // constrollerにて params[:to]で取り出し
            }
          })
        }


      });

    })
  })
}
