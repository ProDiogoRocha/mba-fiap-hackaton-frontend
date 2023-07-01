FROM node:16-alpine as build

ENV HOME=/home/app
WORKDIR $HOME

COPY package.json ./
RUN npm install

COPY . /home/app
RUN npm run build

# production environment
FROM nginx:1.16.0-alpine

COPY --from=build /home/app/ /usr/share/nginx/html/
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]