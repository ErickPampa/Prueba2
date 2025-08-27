/*=============== SHOW MENU ===============*/
const showMenu = (toggleId, navId) =>{
   const toggle = document.getElementById(toggleId),
         nav = document.getElementById(navId)

   toggle.addEventListener('click', () =>{
       // Add show-menu class to nav menu
       nav.classList.toggle('show-menu')
       // Add show-icon to show and hide menu icon
       toggle.classList.toggle('show-icon')
   })
}

showMenu('nav-toggle','nav-menu')

/*=============== SHOW DROPDOWN MENU ===============*/
const dropdownItems = document.querySelectorAll('.dropdown__item')

// 1. Select each dropdown item
dropdownItems.forEach((item) =>{
    const dropdownButton = item.querySelector('.dropdown__button') 

    // 2. Select each button click
    dropdownButton.addEventListener('click', () =>{
        // 7. Select the current show-dropdown class
        const showDropdown = document.querySelector('.show-dropdown')
        
        // 5. Call the toggleItem function
        toggleItem(item)

        // 8. Remove the show-dropdown class from other items
        if(showDropdown && showDropdown!== item){
            toggleItem(showDropdown)
        }
    })
})

// 3. Create a function to display the dropdown
const toggleItem = (item) =>{
    // 3.1. Select each dropdown content
    const dropdownContainer = item.querySelector('.dropdown__container')

    // 6. If the same item contains the show-dropdown class, remove
    if(item.classList.contains('show-dropdown')){
        dropdownContainer.removeAttribute('style')
        item.classList.remove('show-dropdown')
    } else{
        // 4. Add the maximum height to the dropdown content and add the show-dropdown class
        dropdownContainer.style.height = dropdownContainer.scrollHeight + 'px'
        item.classList.add('show-dropdown')
    }
}

/*=============== DELETE DROPDOWN STYLES ===============*/
const mediaQuery = matchMedia('(min-width: 1118px)'),
      dropdownContainer = document.querySelectorAll('.dropdown__container')

// Function to remove dropdown styles in mobile mode when browser resizes
const removeStyle = () =>{
    // Validate if the media query reaches 1118px
    if(mediaQuery.matches){
        // Remove the dropdown container height style
        dropdownContainer.forEach((e) =>{
            e.removeAttribute('style')
        })

        // Remove the show-dropdown class from dropdown item
        dropdownItems.forEach((e) =>{
            e.classList.remove('show-dropdown')
        })
    }
}

addEventListener('resize', removeStyle)


/************************************************* */

document.addEventListener('DOMContentLoaded', function () {
    const images = ['assets/img/image1.webp', 'assets/img/image2.webp', 'assets/img/image3.webp', 'assets/img/image4.webp', 'assets/img/image5.webp']; // Lista de imágenes
    const interval = 7000; // Intervalo de cambio en milisegundos (3 segundos)
  
    let currentImageIndex = 0;
    const mainImage = document.getElementById('main-image');
  
    function changeImage() {
      currentImageIndex = (currentImageIndex + 1) % images.length;
      const newImage = images[currentImageIndex];
      mainImage.style.opacity = 0; // Aplicar transición de opacidad
      setTimeout(() => {
        mainImage.src = newImage;
        mainImage.style.opacity = 1; // Restaurar opacidad
      }, 1000); // Esperar 1 segundo antes de cambiar la imagen
    }
  
    // Iniciar el cambio de imagen en el intervalo especificado
    setInterval(changeImage, interval);
  });
  

  /*************************************************/

  document.addEventListener('DOMContentLoaded', function() {
    var enlaces = document.querySelectorAll('.container-img a');
  
    enlaces.forEach(function(enlace) {
      enlace.addEventListener('click', function(event) {
        event.preventDefault();
        
        var imagenSrc = enlace.querySelector('img').getAttribute('src');
  
        mostrarImagen(imagenSrc);
      });
    });
  });
  
  function mostrarImagen(src) {
    var popup = document.getElementById('popup');
    var popupImage = document.getElementById('popup-image');
  
    popupImage.src = src;
    popup.style.display = 'block';
  }
  
  function cerrarPopup() {
    var popup = document.getElementById('popup');
    popup.style.display = 'none';
  }
  

  