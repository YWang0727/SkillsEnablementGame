<script>
  function getImage(callback) {
    window.avatarInput = document.createElement('input');
    avatarInput.type = 'file';
    avatarInput.accept = 'image/jpeg, image/png';

    avatarInput.onchange = e => {
      var file = e.target.files[0];
      var suffix = file.name.split('.').pop().toLowerCase();

      if (suffix !== 'jpg' && suffix !== 'jpeg' && suffix !== 'png') {
        alert('Please only upload images in jpg or png format.');
        return;
      }

      var reader = new FileReader();
      reader.readAsDataURL(file);

      reader.onload = readerEvent => {
          callback(readerEvent.target.result);
      };
    };
  }
</script>

