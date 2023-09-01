# Skills Enablement Game
## UoB MSc Computer Science summer project with IBM  


<br>

## About project:
Learning can be a solitary experience  - and also In the short term a potentially challenging experience too. To help and encourage people to avail themselves of learning experiences that will enrich their lives - we need to make learning more fun, engaging and collaborative.  


Create a city building game In the form of a web app - where the user builds elements of their city by completing learning experiences.  Each specific learning experience will offer a boost or 'buff' to the city. So for example - completing Agile and Design Thinking learning experiences will allow the city to progress at a faster rate (In terms of building facilities for the population). Whereas AI and Automation could reduce cost of goods and Items - making the population happier.  

To test whether a user has successfully completed a learning experience the game will ask questions to test the knowledge of the user. Once the questions are answered the new capability will be unlocked.  

In the game there will be other cities being built - either by AI or other players. If one city progresses beyond the other cities - then the population will slowly move from other cities Into the more advanced one. This In turn will provide the resources for the city to grow and build new capabilities.


The winner of the game Is the city which has the most population (or all of the population) on the map.  


Learning experiences are to be taken from:  
Skills Build: https://skillsbuild.org/  
IBM Academic Initiative: https://www.ibm.com/academic/home  


<br>

## How to Deploy (Based on Amazon EC2 + Nginx + Amazon Linux):
In the development of this project, we are using **Amazon EC2** as the cloud server and **Nginx** as web server, so the following deployment documents also use Amazon EC2 and Nginx as an example.  
<br>
### **Inbound rules:**  
· Backend: 8080  
· Frontend: 443  
· MySQL: 3306  
· SSH: 22  


### Frontend
1. Frontend files: the **EduCity** folder in this repository.  
2. Open it with Godot: find *HttpLayer.gd* and change the *endpoint_api* in it to your domain name (Your domain must come with an SSL certificate). For example: https://IBMEduCity.com/api/
3. Click Project-Export in the upper left corner and then Add Web. Select your export path. Then copy the following code into Head Include:  

```js
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
```

4. Then export the project. You will find the folder with index.html under your specified path. Copy or upload this folder to the cloud server.  
5. Configure Nginx:  
```Nginx
    server {
	    listen       443 ssl;

        server_name  YOUR_DOMAIN localhost;

        ...
	    [Your SSL configuration]
        ...
  
        root         YOUR_FRONTEND_FOLDER_PATH;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

	    location / {
		    add_header 'Cross-Origin-Opener-Policy' 'same-origin';
		    add_header 'Cross-Origin-Embedder-Policy' 'require-corp';
		    try_files $uri $uri/ /index.html;
	    }

        location /api/ {
            proxy_pass http://localhost:8080/;
	        proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }

        client_max_body_size 20M;
        keepalive_timeout 10;
      
    }
```
6. Test Nginx:   
`sudo nginx -t` 
7. Run Nginx (You may need to change the frontend folder permissions before running it):   
`sudo service nginx start`


### Backend
1. Backend files: the **Backend** folder in this repository.
2. Package it into a .jar via Maven (Configure your ports, your database passwords, etc. before packaging). Copy or upload this folder to the cloud server.  
3. Run backend:   
`nohup java -jar YOUR_JAR_NAME > YOUR_LOG_NAME.txt &`


### MySQL
1. Please create a new empty MySQL database directly in the cloud server and set the password.
2. Use *Game Plan/script8.8.sql* from this repository as the source to create the tables.


