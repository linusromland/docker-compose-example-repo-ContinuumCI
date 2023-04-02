# Stage 1
FROM node:19.1 as build

RUN mkdir -p /frontend/

WORKDIR /frontend/

COPY package*.json .

RUN npm install

COPY . .

RUN npm run build

# Stage 2
FROM nginx:1.23.2-alpine

WORKDIR /nginx/
COPY --from=build /frontend/dist /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/default.conf /etc/nginx/conf.d
RUN rm /etc/nginx/nginx.conf
COPY nginx/nginx.conf /etc/nginx

EXPOSE 3000

CMD nginx -g 'daemon off;'
