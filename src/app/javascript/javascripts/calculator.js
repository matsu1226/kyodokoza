let display = document.getElementById('output');

function set(nums){
    display.textContent += nums.textContent;
    // textContent は Node のプロパティで、ノードおよびその子孫のテキストの内容を表します
    // display.textContent = display.textContent + nums.textContent; 
    // outputに入力されている数字 = outputに入力されている数字 + set関数に代入された数字   
}
function calc(){
    display.textContent = new Function("return "　+ display.textContent)();
    // new Function(function_body)
    // つまり生み出される関数は、function(){return "outputに入力されている数字"}
}

function reset(){
    display.textContent = "";
    // displayの内容は空白に。

}