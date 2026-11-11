// Cria as rotas GET, GET por chave, POST, PUT e DELETE de uma tabela.
// Os nomes de banco/tabela/campos vêm de configurações fixas no server.js;
// valores enviados pelo usuário são sempre passados como parâmetros SQL.
import express from 'express';
import bd from '../bd.js';

export default function criarRotasCrud({ banco, tabela, campos, chaves }) {
  const router = express.Router();
  const tabelaSql = `\`${banco}\`.\`${tabela}\``;
  const whereChave = chaves.map((campo) => `\`${campo}\` = ?`).join(' AND ');
  const nomesChaves = new Set(chaves);
  const camposPermitidos = new Set(campos);

  function valoresChave(req) {
    return chaves.map((campo) => req.params[campo]);
  }

  router.get('/', (req, res) => {
    bd.query(`SELECT * FROM ${tabelaSql}`, (erro, linhas) => {
      if (erro) return res.status(500).json({ msg_erro: erro.message });
      res.json(linhas);
    });
  });

  router.get(`/${chaves.map((c) => `:${c}`).join('/')}`, (req, res) => {
    bd.query(`SELECT * FROM ${tabelaSql} WHERE ${whereChave}`,
      valoresChave(req), (erro, linhas) => {
        if (erro) return res.status(500).json({ msg_erro: erro.message });
        if (linhas.length === 0) return res.status(404).json({ msg_erro: 'Registro não encontrado.' });
        res.json(linhas[0]);
      });
  });

  router.post('/', (req, res) => {
    const dados = Object.fromEntries(
      Object.entries(req.body).filter(([campo]) => camposPermitidos.has(campo) && !nomesChaves.has(campo))
    );
    const nomes = Object.keys(dados);
    if (nomes.length === 0) return res.status(400).json({ msg_erro: 'Envie os campos do registro.' });
    const colunas = nomes.map((c) => `\`${c}\``).join(', ');
    const marcadores = nomes.map(() => '?').join(', ');
    bd.query(`INSERT INTO ${tabelaSql} (${colunas}) VALUES (${marcadores})`,
      nomes.map((c) => dados[c]), (erro, resultado) => {
        if (erro) return res.status(500).json({ msg_erro: erro.message });
        res.status(201).json({ mensagem: 'Registro cadastrado!', id: resultado.insertId || null, ...dados });
      });
  });

  router.put(`/${chaves.map((c) => `:${c}`).join('/')}`, (req, res) => {
    const dados = Object.fromEntries(
      Object.entries(req.body).filter(([campo]) => camposPermitidos.has(campo) && !nomesChaves.has(campo))
    );
    const nomes = Object.keys(dados);
    if (nomes.length === 0) return res.status(400).json({ msg_erro: 'Envie ao menos um campo para atualizar.' });
    const setSql = nomes.map((c) => `\`${c}\` = ?`).join(', ');
    bd.query(`UPDATE ${tabelaSql} SET ${setSql} WHERE ${whereChave}`,
      [...nomes.map((c) => dados[c]), ...valoresChave(req)], (erro, resultado) => {
        if (erro) return res.status(500).json({ msg_erro: erro.message });
        if (resultado.affectedRows === 0) return res.status(404).json({ msg_erro: 'Registro não encontrado.' });
        res.json({ mensagem: 'Registro atualizado!', ...dados });
      });
  });

  router.delete(`/${chaves.map((c) => `:${c}`).join('/')}`, (req, res) => {
    bd.query(`DELETE FROM ${tabelaSql} WHERE ${whereChave}`, valoresChave(req), (erro, resultado) => {
      if (erro) return res.status(500).json({ msg_erro: erro.message });
      if (resultado.affectedRows === 0) return res.status(404).json({ msg_erro: 'Registro não encontrado.' });
      res.json({ mensagem: 'Registro removido com sucesso!' });
    });
  });

  return router;
}
