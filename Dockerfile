# Base
FROM node:16-slim as base
ENV NODE_ENV=production
RUN npm i npm@latest -g
# RUN apt-get install whatever
RUN apt-get autoremove -y; apt-get autoclean; rm -rf /var/lib/{apt,dpkg,cache,log}/
# apt-get is unavailable after this point
EXPOSE 3000
RUN mkdir /app && chown -R node:node /app
WORKDIR /app
USER node
COPY --chown=node:node package*.json ./
RUN npm install --no-optional --silent && npm cache clean --force > "/dev/null" 2>&1

# Development ENV
FROM base as dev
ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
RUN npm install --only=development --no-optional --silent && npm cache clean --force > "/dev/null" 2>&1
CMD ["nodemon", "server.js", "--inspect=0.0.0.0:9229"]

# Source
FROM base as source
COPY --chown=node:node . .

# Test ENV
FROM source as test
ENV NODE_ENV=development
ENV PATH=/app/node_modules/.bin:$PATH
COPY --from=dev /app/node_modules /app/node_modules
RUN eslint .
# RUN npm test // Disabled pending unit tests

# Audit ENV
FROM test as audit
USER root
RUN npm audit --audit-level critical
ARG MICROSCANNER_TOKEN
ADD https://get.aquasec.com/microscanner /
RUN chmod +x /microscanner
RUN /microscanner $MICROSCANNER_TOKEN --continue-on-failure

# Build ENV
FROM source as build
RUN npm run build > "/dev/null" 2>&1

# Production ENV
FROM jonfairbanks/expresshttp
COPY --from=build /app/build ./public
