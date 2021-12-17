export default() => {
  console.log("flash.js読込");
  document.addEventListener("DOMContentLoaded",() => {
    const flash = document.getElementById("flash");
    const DURATION = 2000;
    
    console.log("DOMContentLoaded読込, flash:" + flash);

    function add_flash(){
      flash.classList.remove('hidden');
    }
    function remove_flash(){
      flash.classList.add('hidden');
    }
  
    if(!!flash){
      setTimeout(add_flash, 1);
      setTimeout(remove_flash, DURATION);
    }
  })

}
