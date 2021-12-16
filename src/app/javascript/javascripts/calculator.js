// export default() => {
//   console.log("export defaultできてる");

//   document.addEventListener('DOMContentLoaded',function(){

//     let hidden_field = document.getElementById('hidden_field');
//     let price_display = document.getElementById('price_display');

//     // 画面上のタップキーボードの操作
//     document.addEventListener("dblclick", function(e){ e.preventDefault();}, { passive: false });
//     let b_seven = document.getElementById('b_seven');
//     console.log("b_seven:" + b_seven);

//     b_seven.addEventListener("click", set(b_seven))
//     function set(nums) {
//       console.log("click sevenできてる");
//       hidden_field.value += nums.value;
//       price_display.textContent = hidden_field.value;
//     }

//     function back_space() {
//       hidden_field.value = hidden_field.value.slice(0, -1);
//       price_display.textContent = hidden_field.value;
//     }

//     // PC向け専用の記述（テンキーとキープレスの操作）
//     if (!(navigator.userAgent.indexOf('iPhone') > 0 || navigator.userAgent.indexOf('Android') > 0 && navigator.userAgent.indexOf('Mobile') > 0)) {
//       let contents = document.querySelectorAll('.content_for_calculator');
//       let key_active = true;

//       for(let i = 0; i < contents.length ; i++){
//         contents[i].addEventListener("focus", e =>{
//           key_active = false;
//           console.log(key_active);
//         })
//         contents[i].addEventListener("blur", e =>{
//           key_active = true;
//           console.log(key_active);
//         })
//       }

//       const num_arr = [...Array(10)].map((v, i)=> i.toString(10))

//       document.addEventListener("keydown", e => {
//         let st = e.key;

//         if (key_active && num_arr.includes(st)) {
//           hidden_field.value += st;
//           price_display.textContent = hidden_field.value;
//         }
//         if (key_active && st == "Backspace") {
//           hidden_field.value = hidden_field.value.slice(0, -1);
//           price_display.textContent = hidden_field.value;
//         }
//       })
//     }
//   })
// }
