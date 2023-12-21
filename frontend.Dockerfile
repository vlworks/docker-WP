FROM node:lts-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
EXPOSE 3001
# use the command for your project
CMD ["npm", "run", "watch"]
