<template>
  <main class="login-page">
    <div class="info display-flexed">
      <div>
        <span class="material-icons">account_circle</span>
        <div class="text">Логин</div>
      </div>
      <form id="login-form" name="login-form">
        <input type="text" id="login_in_log_form" v-model="formData.login" :class="{discarded: hasError('login')}" placeholder="Ваш Логин" />
        <input type="text" id="password" v-model="formData.password" :class="{discarded: hasError('password')}" placeholder="Пароль" />
      </form>
      <div>
        <button class="bottom-button" @click="validateForm">Отправить</button>
      </div>
    </div>
  </main>
</template>

<script setup>
import {ref, computed} from "vue";

const formData = ref({
  login: "",
  password: "",
});

const validate = ref({
  catches: false,
});

const validateFields = computed(() => {
  const errors = [];

  if (!validate.value.catches) return errors;

  if (!formData.value.login) errors.push({field: "login", message: ""});

  if (!formData.value.password) errors.push({field: "password", message: ""});

  return errors;
});

function validateForm() {
  console.log("validating fields");
  validate.value.catches = true;
  if (!validateFields.value[0]) sendFormToServer();
}

function hasError(fieldName) {
  return validateFields.value.some((error) => error.field === fieldName);
}

function sendFormToServer() {
  console.log("Sending data to server");

  const loginData = {
    login: formData.value.login,
    passwordy: formData.value.password,
  };

  fetch("http://localhost:8000/api/auth/login", {
    method: "POST",
    headers: {
      "Content-Type": "registration/json",
    },
    body: JSON.stringify(loginData),
  })
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((error) => console.error("Error:", error));
}
</script>

<style lang="scss" scoped>
@keyframes error {
  50% {
    background-color: var(--error);
  }
  100% {
    background-color: var(--light);
  }
}

.discarded {
  transition: 0.2s ease-out;
  animation-name: error;
  animation-duration: 3s;
  animation-iteration-count: infinite;
}

.display-flexed {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.bottom-button {
  justify-self: flex-end;
  margin-bottom: 2rem;
}

button {
  color: var(--light);
  background-color: var(--dark);
  font-size: 2rem;
  border-radius: 0.5rem;
  width: 14rem;
  height: 3rem;
  margin: 1rem;
}

.material-icons {
  font-size: 4rem;
  margin-top: 2rem;
}

form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;

  .text {
    margin: 0rem;
    padding: 0rem;
  }
}

input {
  width: 20rem;
  height: 2rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}
</style>
>
