FROM node:9

# Create app directory
WORKDIR /app

# Install app dependencies

COPY ./package.json /app
COPY ./tsconfig.json /app
COPY ./index.ts /app
COPY ./index.js /app
# Copying rest of the application to app directory
COPY ./package-lock.json /app

#Initialize NPM
RUN npm init -y
RUN npm install express --save


# Expose the port and start the application
Expose 3000

ENTRYPOINT ["node", "index.js"]


