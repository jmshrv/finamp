// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Um leitor de música open source para o Jellyfin';

  @override
  String startupError(String error) {
    return 'Ocorreu um erro durante o arranque da aplicação. O erro foi:$error\n\nPor favor, abra um \"Issue\" em github.com/UnicornsOnLSD/finamp que contenha uma captura deste ecrã. Caso o problema persista, tente limpar os dados da aplicação para a repor para o estado original.';
  }

  @override
  String get about => 'Sobre o Finamp';

  @override
  String get aboutContributionPrompt => 'Feito por pessoas incríveis no seu tempo livre.\nTambém podes ser uma delas!';

  @override
  String get aboutContributionLink => 'Contribui para o Finamp no GitHub:';

  @override
  String get aboutReleaseNotes => 'Lê as notas da última versão:';

  @override
  String get aboutTranslations => 'Ajuda a traduzir o Finamp para o teu idioma:';

  @override
  String get aboutThanks => 'Obrigado por usares o Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Bem vindo ao';

  @override
  String get loginFlowSlogan => 'A tua música, à tua maneira.';

  @override
  String get loginFlowGetStarted => 'Começar!';

  @override
  String get viewLogs => 'Ver Logs';

  @override
  String get changeLanguage => 'Alterar Idioma';

  @override
  String get loginFlowServerSelectionHeading => 'Conectar ao Jellyfin';

  @override
  String get back => 'Voltar';

  @override
  String get serverUrl => 'URL do servidor';

  @override
  String get internalExternalIpExplanation => 'Se pretender aceder ao seu servidor Jellyfin remotamente, deve usar o seu IP público.\n\nSe o seu servidor estiver numa porta padrão de HTTP (80 ou 443) ou na porta padrão do Jellyfin (8096), não precisa de especificar a porta.\n\nSe o URL estiver correto, deverá ver algumas informações sobre o seu servidor aparecerem abaixo do campo de entrada.';

  @override
  String get serverUrlHint => 'ex.: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Ajuda para o URL do Servidor';

  @override
  String get emptyServerUrl => 'O URL do servidor não pode estar em branco';

  @override
  String get connectingToServer => 'Conectando ao servidor...';

  @override
  String get loginFlowLocalNetworkServers => 'Servidores na rede local:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Procurando servidores...';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecione a sua conta';

  @override
  String get backToServerSelection => 'Voltar à Seleção de Servidor';

  @override
  String get loginFlowNamelessUser => 'Utilizador Sem Nome';

  @override
  String get loginFlowCustomUser => 'Utilizador Personalizado';

  @override
  String get loginFlowAuthenticationHeading => 'Inicie sessão na sua conta';

  @override
  String get backToAccountSelection => 'Voltar à Seleção de Conta';

  @override
  String get loginFlowQuickConnectPrompt => 'Use o código Quick Connect';

  @override
  String get loginFlowQuickConnectInstructions => 'Abra a aplicação ou o site do Jellyfin, clique no ícone do seu utilizador e selecione Quick Connect.';

  @override
  String get loginFlowQuickConnectDisabled => 'O Quick Connect está desativado neste servidor.';

  @override
  String get orDivider => 'ou';

  @override
  String get loginFlowSelectAUser => 'Selecione um utilizador';

  @override
  String get username => 'Nome de utilizador';

  @override
  String get usernameHint => 'Insira o seu nome de utilizador';

  @override
  String get usernameValidationMissingUsername => 'Por favor, insira um nome de utilizador';

  @override
  String get password => 'Palavra-passe';

  @override
  String get passwordHint => 'Insira a sua palavra-passe';

  @override
  String get login => 'Iniciar Sessão';

  @override
  String get logs => 'Registos';

  @override
  String get next => 'Próximo';

  @override
  String get selectMusicLibraries => 'Selecionar Bibliotecas de Música';

  @override
  String get couldNotFindLibraries => 'Não foi possível encontrar nenhuma biblioteca.';

  @override
  String get unknownName => 'Nome Desconhecido';

  @override
  String get tracks => 'Faixas';

  @override
  String get albums => 'Álbuns';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Estilos';

  @override
  String get playlists => 'Listas de Reprodução';

  @override
  String get startMix => 'Iniciar Mistura';

  @override
  String get startMixNoTracksArtist => 'Pressione e segure um artista para o adicionar ou remover do construtor de misturas antes de iniciar uma mistura';

  @override
  String get startMixNoTracksAlbum => 'Pressione e segure um álbum para o adicionar ou remover do construtor de mistura antes de iniciar uma mistura';

  @override
  String get startMixNoTracksGenre => 'Pressione e segure um estilo para o adicionar ou remover do construtor de mistura antes de iniciar uma mistura';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Misturar todas';

  @override
  String get downloads => 'Transferências';

  @override
  String get settings => 'Definições';

  @override
  String get offlineMode => 'Modo Offline';

  @override
  String get sortOrder => 'Ordenação';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get title => 'Título';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista do Álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Orçamento';

  @override
  String get communityRating => 'Avaliação da Comunidade';

  @override
  String get criticRating => 'Avaliação dos Críticos';

  @override
  String get dateAdded => 'Adicionado em';

  @override
  String get datePlayed => 'Reproduzido em';

  @override
  String get playCount => 'Contagem de reproduções';

  @override
  String get premiereDate => 'Data de Lançamento';

  @override
  String get productionYear => 'Ano de Produção';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Aleatório';

  @override
  String get revenue => 'Receita';

  @override
  String get runtime => 'Duração';

  @override
  String get syncDownloadedPlaylists => 'Sincronizar listas de reprodução descarregadas';

  @override
  String get downloadMissingImages => 'Transferir imagens inexistentes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens em falta descarregadas',
      one: '$count imagem em falta transferida',
      zero: 'Não foram encontradas imagens em falta',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Transferências em Progresso';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descarregados',
      one: '$count descarregado',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount faixas',
      one: '$trackCount faixa',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount imagens',
      one: '$imageCount imagem',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nós a sincronizar',
      one: '$syncCount nó a sincronizar',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nA reparar neste momento',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count concluídas';
  }

  @override
  String dlFailed(int count) {
    return '$count falharam';
  }

  @override
  String dlEnqueued(int count) {
    return '$count em espera';
  }

  @override
  String dlRunning(int count) {
    return '$count em execução';
  }

  @override
  String get activeDownloadsTitle => 'Transferências em Progresso';

  @override
  String get noActiveDownloads => 'Sem transferências em progresso.';

  @override
  String get errorScreenError => 'Ocorreu um erro ao aceder à lista de erros! Neste caso, recomendados que abra um issue no nosso GitHub e que limpe os dados da aplicação';

  @override
  String get failedToGetTrackFromDownloadId => 'Falha a obter a faixa através do download ID';

  @override
  String deleteDownloadsPrompt(String itemName, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'track': 'track',
        'library': 'library',
        'other': 'item',
      },
    );
    return 'Are you sure you want to delete the $_temp0 \'$itemName\' from this device?';
  }

  @override
  String get deleteDownloadsConfirmButtonText => 'Delete';

  @override
  String get specialDownloads => 'Special downloads';

  @override
  String get noItemsDownloaded => 'No items downloaded.';

  @override
  String get error => 'Erro';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'Reproduzir';

  @override
  String get shuffleButtonLabel => 'Aleatório';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0, $downloads Transferidas';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0 Transferidas';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar nome da lista de reprodução';

  @override
  String get editPlaylistNameTitle => 'Editar Nome da Lista de Reprodução';

  @override
  String get required => 'Obrigatório';

  @override
  String get updateButtonLabel => 'Atualizar';

  @override
  String get playlistNameUpdated => 'Nome da lista de reprodução atualizado.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Transferências eliminadas.';

  @override
  String get addDownloads => 'Adicionar Transferências';

  @override
  String get location => 'Localização';

  @override
  String get confirmDownloadStarted => 'Transferência iniciada';

  @override
  String get downloadsQueued => 'Transferência preparada, a descarregar ficheiros';

  @override
  String get addButtonLabel => 'Adicionar';

  @override
  String get shareLogs => 'Partilhar relatórios';

  @override
  String get logsCopied => 'Relatórios copiados.';

  @override
  String get message => 'Mensagem';

  @override
  String get stackTrace => 'Traçado da Pilha';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licenciado com a Mozilla Public License 2.0.\nO código-fonte está disponível em $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transcodificação';

  @override
  String get downloadLocations => 'Locais de Transferências';

  @override
  String get audioService => 'Serviço de Áudio';

  @override
  String get interactions => 'Interações';

  @override
  String get layoutAndTheme => 'Disposição e Tema';

  @override
  String get notAvailableInOfflineMode => 'Não disponível no modo offline';

  @override
  String get logOut => 'Terminar Sessão';

  @override
  String get downloadedTracksWillNotBeDeleted => 'As músicas transferidas não serão eliminadas';

  @override
  String get areYouSure => 'Tem a certeza?';

  @override
  String get jellyfinUsesAACForTranscoding => 'O Jellyfin utiliza AAC para transcodificação';

  @override
  String get enableTranscoding => 'Ativar Transcodificação';

  @override
  String get enableTranscodingSubtitle => 'Transcodifica no servidor.';

  @override
  String get bitrate => 'Taxa de bits';

  @override
  String get bitrateSubtitle => 'Uma taxa de bits mais alta oferece áudio de melhor qualidade, mas consome uma largura de banda maior.';

  @override
  String get customLocation => 'Localização Personalizada';

  @override
  String get appDirectory => 'Diretório de apps';

  @override
  String get addDownloadLocation => 'Adicionar Local de Transferências';

  @override
  String get selectDirectory => 'Selecione o Diretório';

  @override
  String get unknownError => 'Erro Desconhecido';

  @override
  String get pathReturnSlashErrorMessage => 'Caminhos que retornam \"/\" não podem ser usados';

  @override
  String get directoryMustBeEmpty => 'Diretório deve estar vazio';

  @override
  String get customLocationsBuggy => 'Localizações customizadas são extremamente defeituosas devidas à problems com permissões. Estou pensando em maneiras de consertar isso, mas por enquanto não recomendaria usá-las.';

  @override
  String get enterLowPriorityStateOnPause => 'Entrar Estado de Baixa-Prioridade durante Pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Permite que a notificação seja apagada quando pausada. Também permite que o Android elimine o serviço quando pausado.';

  @override
  String get shuffleAllTrackCount => 'Contagem da Mistura de Todas as Faixas';

  @override
  String get shuffleAllTrackCountSubtitle => 'Quantidade de faixas a carregar quando se usa o botão misturar todas as faixas.';

  @override
  String get viewType => 'Tipo de Visualização';

  @override
  String get viewTypeSubtitle => 'Tipo de visualização para o ecrã de música';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Grade';

  @override
  String get customizationSettingsTitle => 'Personalização';

  @override
  String get playbackSpeedControlSetting => 'Visibilidade da Velocidade de Reprodução';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Se os controlos de velocidade de reprodução são exibidos no menu do ecrã do leitor';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automático:\nO Finamp tenta identificar se a faixa que está a reproduzir é um podcast ou (parte de) um audiolivro. Isto é considerado verdadeiro se a faixa tiver mais de $trackDuration minutos, se o álbum da faixa tiver mais de $albumDuration horas, ou se a faixa tiver pelo menos um destes estilos atribuídos: $genreList.\nOs controlos de velocidade de reprodução serão então exibidos no menu do ecrã do leitor.\n\nExibido:\nOs controlos de velocidade de reprodução serão sempre exibidos no menu do ecrã do leitor.\n\nOculto:\nOs controlos de velocidade de reprodução no menu do ecrã do leitor estão sempre ocultos.';
  }

  @override
  String get automatic => 'Automático';

  @override
  String get shown => 'Exibido';

  @override
  String get hidden => 'Oculto';

  @override
  String get speed => 'Velocidade';

  @override
  String get reset => 'Repor';

  @override
  String get apply => 'Aplicar';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisagem';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Contagem Eixo Cruzado da Grade';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Quantidade de ícones da grade para usar em cada fila quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto na visualização em grade';

  @override
  String get showTextOnGridViewSubtitle => 'Mostrar ou não o texto (título, artista, etc) na grelha do ecrã de música.';

  @override
  String get useCoverAsBackground => 'Mostrar capa desfocada como plano de fundo do player';

  @override
  String get useCoverAsBackgroundSubtitle => 'Usar ou não usar arte de capas desfocadas como fundo do ecrã to reprodutor.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Espaçamento Mínimo da Capa do Álbum';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Espaçamento mínimo ao redor da capa do álbum na tela de reprodução, em % da largura da tela.';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Ocultar artistas das faixas, se iguais aos artistas do álbum';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Se deve mostrar os artistas das faixas no ecrã do álbum, no caso destes não serem diferentes dos do álbum.';

  @override
  String get showArtistsTopTracks => 'Mostrar faixas principais na vista do artista';

  @override
  String get showArtistsTopTracksSubtitle => 'Indica se deve mostrar as 5 faixas mais ouvidas de um artista.';

  @override
  String get disableGesture => 'Desativar gestos';

  @override
  String get disableGestureSubtitle => 'Se deseja desativar gestos.';

  @override
  String get showFastScroller => 'Mostrar rolagem rápida';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get tabs => 'Abas';

  @override
  String get playerScreen => 'Tela de Reprodução';

  @override
  String get cancelSleepTimer => 'Cancelar o Cronômetro de Sono?';

  @override
  String get yesButtonLabel => 'Sim';

  @override
  String get noButtonLabel => 'Não';

  @override
  String get setSleepTimer => 'Configurar o Cronômetro de Sono';

  @override
  String get hours => 'Horas';

  @override
  String get seconds => 'Segundos';

  @override
  String get minutes => 'Minutos';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime de $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Faixa $currentTrackIndex de $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Número Inválido';

  @override
  String get sleepTimerTooltip => 'Cronômetro de Sono';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Dormindo em $time minutos';
  }

  @override
  String get addToPlaylistTooltip => 'Adicionar à lista de reprodução';

  @override
  String get addToPlaylistTitle => 'Adicionar à Lista de Reprodução';

  @override
  String get addToMorePlaylistsTooltip => 'Adicionar a mais playlists';

  @override
  String get addToMorePlaylistsTitle => 'Adicionar a Mais Playlists';

  @override
  String get removeFromPlaylistTooltip => 'Remover desta lista de reprodução';

  @override
  String get removeFromPlaylistTitle => 'Remover Desta Lista de Reprodução';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remover da playlist \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remover da playlist \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nova Lista de Reprodução';

  @override
  String get createButtonLabel => 'Criar';

  @override
  String get playlistCreated => 'Lista de reprodução criada.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Toque para adicionar à playlist. Pressione e segure para alternar favorito.';

  @override
  String get noAlbum => 'Nenhum Álbum';

  @override
  String get noItem => 'Nenhum Ítem';

  @override
  String get noArtist => 'Nenhum Artista';

  @override
  String get unknownArtist => 'Artista Desconhecido';

  @override
  String get unknownAlbum => 'Álbum Desconhecido';

  @override
  String get playbackModeDirectPlaying => 'Reprodução Direta';

  @override
  String get playbackModeTranscoding => 'Reprodução Transcodificada';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Reprodução Local';

  @override
  String get queue => 'Fila';

  @override
  String get addToQueue => 'Adicionar à Fila';

  @override
  String get replaceQueue => 'Trocar a Fila';

  @override
  String get instantMix => 'Mistura Instantânea';

  @override
  String get goToAlbum => 'Ir para Álbum';

  @override
  String get goToArtist => 'Ir para o Artista';

  @override
  String get goToGenre => 'Ir para o Estilo';

  @override
  String get removeFavourite => 'Remover Favorito';

  @override
  String get addFavourite => 'Adicionar Favorito';

  @override
  String get confirmFavoriteAdded => 'Favorito Adicionado';

  @override
  String get confirmFavoriteRemoved => 'Favorito Removido';

  @override
  String get addedToQueue => 'Adicionado à fila.';

  @override
  String get insertedIntoQueue => 'Inserido na fila.';

  @override
  String get queueReplaced => 'Fila trocada.';

  @override
  String get confirmAddedToPlaylist => 'Adicionado à playlist.';

  @override
  String get removedFromPlaylist => 'Removido da lista de reprodução.';

  @override
  String get startingInstantMix => 'Iniciando mistura instantânea.';

  @override
  String get anErrorHasOccured => 'Ocorreu um erro.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de condição $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de condição $statusCode. Isto provavelmente significa que usou um nome de utilizador/palavra-passe errados, ou o seu cliente não está mais autenticado.';
  }

  @override
  String get removeFromMix => 'Remover da Mistura';

  @override
  String get addToMix => 'Adicionar à Mistura';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens baixados novamente',
      one: '$count item baixado novamente',
      zero: 'Não são necessários novos downloads.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duração do buffer';

  @override
  String get bufferDurationSubtitle => 'A duração máxima que deve ser colocada em buffer, em segundos. Requer reinicialização.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Não limitar o tamanho do buffer';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Desativa as restrições do tamanho do buffer. O buffer será sempre carregado de acordo com a duração configurada, mesmo para ficheiros muito grandes. Pode causar instabilidade. É necessário restart.';

  @override
  String get bufferSizeTitle => 'Tamanho do buffer';

  @override
  String get bufferSizeSubtitle => 'O tamanho máximo do buffer em MB. É necessário restart';

  @override
  String get language => 'Linguagem';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Ir para o início ou para a faixa anterior';

  @override
  String get skipToNextTrackButtonTooltip => 'Ir para a próxima faixa';

  @override
  String get togglePlaybackButtonTooltip => 'Alternar reprodução';

  @override
  String get previousTracks => 'Faixas Anteriores';

  @override
  String get nextUp => 'A Seguir';

  @override
  String get clearNextUp => 'Limpar A Seguir';

  @override
  String get clearQueue => 'Clear Queue';

  @override
  String get playingFrom => 'A Reproduzir de';

  @override
  String get playNext => 'Reproduzir a seguir';

  @override
  String get addToNextUp => 'Adicionar a Seguir';

  @override
  String get shuffleNext => 'Aleatorizar a seguir';

  @override
  String get shuffleToNextUp => 'Colocar como aleatório no final dos temas a seguir';

  @override
  String get shuffleToQueue => 'Adicionar à Fila aleatoriamente';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'Album',
        'artist': 'Artist',
        'playlist': 'Playlist',
        'genre': 'Genre',
        'other': 'Item',
      },
    );
    return '$_temp0 vai tocar a seguir';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Track',
        'album': 'album',
        'artist': 'artist',
        'playlist': 'playlist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Adicionar $_temp0 a seguir';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'track',
        'album': 'album',
        'artist': 'artist',
        'playlist': 'playlist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Adicionaste $_temp0 à Fila';
  }

  @override
  String get confirmShuffleNext => 'Foi colocada como aleatória a seguir';

  @override
  String get confirmShuffleToNextUp => 'Adicionada como aleatória a seguir';

  @override
  String get confirmShuffleToQueue => 'Adicionada como aleatória à Fila';

  @override
  String get placeholderSource => 'Algures';

  @override
  String get playbackHistory => 'Histórico de Reprodução';

  @override
  String get shareOfflineListens => 'Partilhar ouvidas offline';

  @override
  String get yourLikes => 'As Tuas Favoritas';

  @override
  String mix(String mixSource) {
    return 'Mistura - $mixSource';
  }

  @override
  String get tracksFormerNextUp => 'Faixas adicionadas através das a seguir';

  @override
  String get savedQueue => 'Fila Gravada';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'trackMix': 'Track Mix',
        'artistMix': 'Artist Mix',
        'albumMix': 'Album Mix',
        'genreMix': 'Genre Mix',
        'favorites': 'Favorites',
        'allTracks': 'All Tracks',
        'filteredList': 'Tracks',
        'genre': 'Genre',
        'artist': 'Artist',
        'track': 'Track',
        'nextUpAlbum': 'Album in Next Up',
        'nextUpPlaylist': 'Playlist in Next Up',
        'nextUpArtist': 'Artist in Next Up',
        'other': '',
      },
    );
    return 'A Tocar de $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Todas Aleatórias';

  @override
  String get playbackOrderLinearButtonLabel => 'A Reproduzir em Ordem';

  @override
  String get playbackOrderLinearButtonTooltip => 'A reproduzir por ordem. Toca para aleatório.';

  @override
  String get playbackOrderShuffledButtonLabel => 'A reproduzir aleatoriamente';

  @override
  String get playbackOrderShuffledButtonTooltip => 'A reproduzir aleatoriamente. Toca para reproduzir por ordem.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'A tocar à velocidade de x$speed';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'Velocidade x$speed';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Diminuir velocidade de reprodução';

  @override
  String get playbackSpeedIncreaseLabel => 'Aumentar velocidade de reprodução';

  @override
  String get loopModeNoneButtonLabel => 'Sem Repetição';

  @override
  String get loopModeOneButtonLabel => 'A Repetir Esta Faixa';

  @override
  String get loopModeAllButtonLabel => 'A Repetir Todos';

  @override
  String get queuesScreen => 'Restaurar A Tocar';

  @override
  String get queueRestoreButtonLabel => 'Restaurar';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Gravado $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'A Tocar: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tracks',
      one: '1 Track',
    );
    return '$_temp0, $remaining Por Tocar';
  }

  @override
  String get queueLoadingMessage => 'A restaurar a Fila...';

  @override
  String get queueRetryMessage => 'Falha a restaurar a fila. Tentar novamente?';

  @override
  String get autoloadLastQueueOnStartup => 'Auto-restaurar a Última Fila';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Tentar restaurar a última Fila ao iniciar.';

  @override
  String get reportQueueToServer => 'Reportar a Fila atual ao servidor?';

  @override
  String get reportQueueToServerSubtitle => 'Quando ativado, o Finamp vai enviar a Fila atual para o servidor. Esta funcionalidade não é muito utilizada e aumenta o tráfego na rede.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Frequência de atualização da sessão de reprodução';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Com que frequência deve enviar o estado da reprodução atual para o servido. Deverá ser menos de 5 minutos (300 segundos), para evitar que a sessão expire.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Se o servidor do Jellyfin não recebeu nenhuma atualização de nenhum cliente nos últimos 5 minutos, assume que a reprodução acabou. Isto significa que, para faixas maiores do que 5 minutos, a reprodução pode ser incorretamente reportada como terminada, o que reduz a qualidade dos dados reportados sobre a reprodução.';

  @override
  String get topTracks => 'Temas Mais Tocados';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Álbuns',
      one: '$count Álbum',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Aleatorizar Álbuns';

  @override
  String get shuffleAlbumsNext => 'Aleatorizar Álbuns a Seguir';

  @override
  String get shuffleAlbumsToNextUp => 'Tocar álbuns aleatoriamente a seguir';

  @override
  String get shuffleAlbumsToQueue => 'Aleatorizar Álbuns Na Fila';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount reproduções',
      one: '$playCount reprodução',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'album',
        'playlist': 'playlist',
        'trackMix': 'track mix',
        'artistMix': 'artist mix',
        'albumMix': 'album mix',
        'genreMix': 'genre mix',
        'favorites': 'favorites',
        'allTracks': 'all tracks',
        'filteredList': 'tracks',
        'genre': 'genre',
        'artist': 'artist',
        'track': 'track',
        'nextUpAlbum': 'album in next up',
        'nextUpPlaylist': 'playlist in next up',
        'nextUpArtist': 'artist in next up',
        'other': '',
      },
    );
    return 'Não foi possível carregar $_temp0';
  }

  @override
  String get confirm => 'Confirme';

  @override
  String get close => 'Fechar';

  @override
  String get showUncensoredLogMessage => 'Este log contém suas informações de login. Mostrar?';

  @override
  String get resetTabs => 'Redefinir guias';

  @override
  String get resetToDefaults => 'Restaurar definições';

  @override
  String get noMusicLibrariesTitle => 'Sem bibliotecas de música';

  @override
  String get noMusicLibrariesBody => 'O Finamp não encontrou nenhuma biblioteca de musica. Certifica-te que o teu servidor Jellyfin tem pelo menos uma biblioteca com o tipo de conteúdo definido como “Música”.';

  @override
  String get refresh => 'Atualizar';

  @override
  String get moreInfo => 'Mais Informação';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalização de Volume';

  @override
  String get volumeNormalizationSwitchTitle => 'Ativar Normalização de Volume';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Usar informações de ganho para normalizar o volume das faixas (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Modo de Normalização de Volume';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Quando e como aplicar a Normalização de Volume';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Híbrido (Faixa + Álbum):\nO ganho da faixa é usado para reprodução normal, mas, se um álbum estiver a ser reproduzido (seja porque é a principal fonte da fila de reprodução ou porque foi adicionado à fila em algum momento), o ganho do álbum será usado em vez disso.\n\nBaseado em Faixas:\nO ganho da faixa é sempre usado, independentemente de um álbum estar a ser reproduzido ou não.\n\nApenas Álbuns:\nA Normalização de Volume é aplicada apenas ao reproduzir álbuns (usando o ganho do álbum), mas não para faixas individuais.';

  @override
  String get volumeNormalizationModeHybrid => 'Híbrido (Faixa + Álbum)';

  @override
  String get volumeNormalizationModeTrackBased => 'Baseado em Faixas';

  @override
  String get volumeNormalizationModeAlbumBased => 'Baseado em Álbuns';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Apenas Álbuns';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Ganho Base';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Atualmente, a Normalização de Volume no iOS requer a alteração do volume de reprodução para emular a mudança de ganho. Como não podemos aumentar o volume acima de 100%, precisamos diminuir o volume por padrão para podermos aumentar o volume das faixas mais baixas. O valor é em decibéis (dB), onde -10 dB corresponde a ~30% de volume, -4,5 dB a ~60% de volume e -2 dB a ~80% de volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Reproduzir Faixa Deslizada a Seguir';

  @override
  String get swipeInsertQueueNextSubtitle => 'Ativar para inserir uma faixa como próximo item na fila ao ser deslizada na lista de faixas, em vez de adicioná-la ao final.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Iniciar Mistura Instantânea para Temas Individuais';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Quando ativado, pressionar num tema na tab dos temas começa uma mistura instantânea desse tema, em vez de apenas tocar esse tema.';

  @override
  String get downloadItem => 'Download';

  @override
  String get repairComplete => 'Reparação dos Downloads completa.';

  @override
  String get syncComplete => 'Todos os downloads foram sincronizados.';

  @override
  String get syncDownloads => 'Sincronizar e fazer download dos itens em falta.';

  @override
  String get repairDownloads => 'Problemas com a reparação de download de ficheiros ou metadados.';

  @override
  String get requireWifiForDownloads => 'É necessário WiFi para fazer download.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tracks',
      one: '$count track',
    );
    return 'Aviso: $_temp0 não pode ser restaurada para a Fila.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Running',
        'failed': 'Failed',
        'syncFailed': 'Repeatedly Unsynced',
        'enqueued': 'Queued',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Downloads',
      one: 'Download',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Tens a certeza que queres fazer download de todo o conteúdo da biblioteca \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Mostrar apenas álbuns descarregados';

  @override
  String get filesystemFull => 'Downloads em falta não podem ser completados. O sistema de ficheiros está cheio.';

  @override
  String get connectionInterrupted => 'Conexão interrompida, a pausar os downloads.';

  @override
  String get connectionInterruptedBackground => 'A conexão foi interrompida enquanto fazia o download. Isto pode ser causado por configurações de sistema.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'A conexão foi interrompida durante o download. Isto pode ser causado por ativar \'Entrar em Estado de Baixa Prioridade na Pausa\' ou por configurações de sistema.';

  @override
  String get activeDownloadSize => 'A fazer download...';

  @override
  String get missingDownloadSize => 'A Apagar...';

  @override
  String get syncingDownloadSize => 'A Sincronizar...';

  @override
  String get runRepairWarning => 'Não foi possível contactar o servidor para finalizar a migração dos downloads. Por favor corre \'Reparar Downloads\' através do ecrã de downloads logo que estejas online.';

  @override
  String get downloadSettings => 'Downloads';

  @override
  String get showNullLibraryItemsTitle => 'Mostrar Media com Biblioteca Desconhecida.';

  @override
  String get showNullLibraryItemsSubtitle => 'Alguma media pode ter sido baixada com uma biblioteca desconhecida. Desativa para esconder a coleção original.';

  @override
  String get maxConcurrentDownloads => 'Máximo de Downloads em Simultâneo';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Aumentar o número de downloads concorrentes pode permitir aumento de download, mas pode também causar falhas se o ficheiro for muito grande ou causar lag excessivo em alguns casos.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count Downloads Concorrentes';
  }

  @override
  String get downloadsWorkersSetting => 'Número de processos que fazem download';

  @override
  String get downloadsWorkersSettingSubtitle => 'Quantidade de processos usados para sincronizar metadata e remover downloads. Aumentar este valor pode aumentar a velocidade de sincronização e remoção, especialmente quando há muita latência, mas pode introduzir atraso (lag).';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count Processos de Download';
  }

  @override
  String get syncOnStartupSwitch => 'Sincronizar Downloads Automaticamente ao Iniciar';

  @override
  String get preferQuickSyncSwitch => 'Preferir Sincronização Rápida';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Itens estáticos (faixas e álbuns) não serão atualizados quando é feita a sincronização. Reparação de downloads fará sempre uma sincronização completa.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Track',
        'library': 'Library',
        'unknown': 'Item',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return '$parentName necessita de fazer o download deste item.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favorites',
        'allPlaylists': 'All Playlists',
        'fiveLatestAlbums': '5 Latest Albums',
        'allPlaylistsMetadata': 'Playlist Metadata',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Imagens armazenadas para \'$libraryName\'';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Selecionar Contentor de Transcodificação';

  @override
  String get transcodingStreamingContainerSubtitle => 'Selecione o contentor de segmentos a usar ao transmitir áudio transcodificado. As faixas já na fila não serão afetadas.';

  @override
  String get downloadTranscodeEnableTitle => 'Ativar Transferências Transcodificadas';

  @override
  String get downloadTranscodeCodecTitle => 'Seleciona o Codec para Download';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Always',
        'never': 'Never',
        'ask': 'Ask',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Taxa de Transferência';

  @override
  String get downloadBitrateSubtitle => 'Uma taxa de bits mais alta oferece áudio de melhor qualidade, mas exige mais espaço de armazenamento.';

  @override
  String get transcodeHint => 'Transcodificar?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Fazer download como $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate Transcodificado',
      },
    );
    return '$size $codec$_temp0';
  }

  @override
  String collectionDownloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': ' as $codec @ $bitrate',
      },
    );
    return '$size$_temp0';
  }

  @override
  String dontTranscode(String description) {
    String _temp0 = intl.Intl.selectLogic(
      description,
      {
        'null': '',
        'other': ' - $description',
      },
    );
    return 'Download original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Transcodificar novo download em fila.';

  @override
  String get redownloadTitle => 'Fazer Novo Download de Transcodes Automaticamente';

  @override
  String get redownloadSubtitle => 'Fazer novo download de faixas automaticamente. É esperado que as faixas estejam numa qualidade diferente devido a alterações na coleção.';

  @override
  String get defaultDownloadLocationButton => 'Definir como local de download por defeito. Desativar para selecionar por download.';

  @override
  String get fixedGridSizeSwitchTitle => 'Usar grelha de tamanho fixo';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Tamanho da grelha não se altera de acordo com o tamanho do ecrã.';

  @override
  String get fixedGridSizeTitle => 'Tamanho da Grelha';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Small',
        'medium': 'Medium',
        'large': 'Large',
        'veryLarge': 'Very Large',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Permitir Modo de Divisão de Ecrã';

  @override
  String get allowSplitScreenSubtitle => 'O reprodutor será apresentado ao lado de outras vistas em ecrãs mais largos.';

  @override
  String get enableVibration => 'Ativar vibração';

  @override
  String get enableVibrationSubtitle => 'Se deve ativar vibração.';

  @override
  String get hideQueueButton => 'Hide queue button';

  @override
  String get hideQueueButtonSubtitle => 'Hide the queue button on the player screen. Swipe up to access the queue.';

  @override
  String get oneLineMarqueeTextButton => 'Auto-scroll Long Titles';

  @override
  String get oneLineMarqueeTextButtonSubtitle => 'Automatically scroll track titles that are too long to display in two lines';

  @override
  String get marqueeOrTruncateButton => 'Use ellipsis for long titles';

  @override
  String get marqueeOrTruncateButtonSubtitle => 'Show ... at the end of long titles instead of scrolling text';

  @override
  String get hidePlayerBottomActions => 'Esconder ações abaixo';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Esconder a fila e botão de letras no ecrã do reprodutor. Desliza para cima para aceder à fila, desliza para a esquerda (por baixo da capa do álbum) para ver as letras (se disponíveis).';

  @override
  String get prioritizePlayerCover => 'Priorizar a capa do álbum';

  @override
  String get prioritizePlayerCoverSubtitle => 'Priorizar mostrar uma capa de álbum maior no ecrã do reprodutor. Controladores não críticos serão escondidos mais agressivamente em ecrãs mais pequenos.';

  @override
  String get suppressPlayerPadding => 'Remover o preenchimento dos controlos no reprodutor';

  @override
  String get suppressPlayerPaddingSubtitle => 'Minimiza o preenchimento completo entre os controlos no ecrã do reprodutor, quando a capa do álbum não está em tamanho completo.';

  @override
  String get lockDownload => 'Manter Sempre no Dispositivo';

  @override
  String get showArtistChipImage => 'Mostrar imagens do artista com o nome do artista';

  @override
  String get showArtistChipImageSubtitle => 'Afeta a visualização das imagens de artista, tais como as do ecrã do reprodutor.';

  @override
  String get scrollToCurrentTrack => 'Voltar à faixa atual';

  @override
  String get enableAutoScroll => 'Ativar scroll automático';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit bit';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration restante';
  }

  @override
  String get removeFromPlaylistConfirm => 'Remover';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Remover \'$itemName\' da lista de reprodução \'$playlistName\'?';
  }

  @override
  String get trackMenuButtonTooltip => 'Menu de Faixas';

  @override
  String get quickActions => 'Ações Rápidas';

  @override
  String get addRemoveFromPlaylist => 'Adicionar às / Remover das Listas de Reprodução';

  @override
  String get addPlaylistSubheader => 'Adicionar faixa à lista de reprodução';

  @override
  String get trackOfflineFavorites => 'Sincronizar todos os favoritos';

  @override
  String get trackOfflineFavoritesSubtitle => 'Isto permite mostrar os favoritos mais atualizados quando offline. Não faz download de ficheiros adicionais.';

  @override
  String get allPlaylistsInfoSetting => 'Fazer Download de Metadados da Lista de Reprodução';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Sincronizar metadados para todas as listas de reprodução. Melhora a experiência com as listas de reprodução';

  @override
  String get downloadFavoritesSetting => 'Fazer download dos favoritos';

  @override
  String get downloadAllPlaylistsSetting => 'Fazer download de todas as listas de reprodução';

  @override
  String get fiveLatestAlbumsSetting => 'Fazer download dos últimos 5 álbuns';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Os downloads serão removidos à medida que envelhecem. Bloqueia o download para prevenir que o álbum seja removido.';

  @override
  String get cacheLibraryImagesSettings => 'Guardar imagens da biblioteca atual';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Será feito o download de todas as capas dos álbuns, artistas, estilos e listas de reprodução da biblioteca ativa atual.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Mostrar o progresso da faixa no mini-reprodutor dentro da aplicação';

  @override
  String get showProgressOnNowPlayingBarSubtitle => 'Controla se o mini-reprodutor dentro da aplicação / a tocar agora no fundo do ecrã da música funciona como barra de progresso.';

  @override
  String get lyricsScreen => 'Vista das Letras';

  @override
  String get showLyricsTimestampsTitle => 'Mostrar altura para sincronização das letras';

  @override
  String get showLyricsTimestampsSubtitle => 'Controla se a altura da linha de cada letra é mostrada na vista das letras, se disponível.';

  @override
  String get showStopButtonOnMediaNotificationTitle => 'Mostrar botão de paragem na notificação de media';

  @override
  String get showStopButtonOnMediaNotificationSubtitle => 'Controla se a notificação de media tem um botão de paragem além do botão de pausa. Isto permite-te para a reprodução sem abrir a aplicação.';

  @override
  String get showSeekControlsOnMediaNotificationTitle => 'Mostrar controlos de procura na notificação de media';

  @override
  String get showSeekControlsOnMediaNotificationSubtitle => 'Controla de a notificação de media tem uma barra de progresso. Isto permite-te alterar a posição da reprodução sem abrir a aplicação.';

  @override
  String get alignmentOptionStart => 'Iniciar';

  @override
  String get alignmentOptionCenter => 'Centrar';

  @override
  String get alignmentOptionEnd => 'Finalidade';

  @override
  String get fontSizeOptionSmall => 'Pequena';

  @override
  String get fontSizeOptionMedium => 'Média';

  @override
  String get fontSizeOptionLarge => 'Grande';

  @override
  String get lyricsAlignmentTitle => 'Alinhamento das letras';

  @override
  String get lyricsAlignmentSubtitle => 'Controla o alinhamento das letras na vista de letras.';

  @override
  String get lyricsFontSizeTitle => 'Tamanho do texto das letras';

  @override
  String get lyricsFontSizeSubtitle => 'Controla o tamanho do texto das letras na vista das letras.';

  @override
  String get showLyricsScreenAlbumPreludeTitle => 'Mostrar o álbum antes das letras';

  @override
  String get showLyricsScreenAlbumPreludeSubtitle => 'Controla se a capa do álbum é mostrada por cima das letras, antes de navegar para baixo.';

  @override
  String get keepScreenOn => 'Manter o Ecrã Ligado';

  @override
  String get keepScreenOnSubtitle => 'Quando manter o ecrã ligado';

  @override
  String get keepScreenOnDisabled => 'Desativado';

  @override
  String get keepScreenOnAlwaysOn => 'Sempre Ativado';

  @override
  String get keepScreenOnWhilePlaying => 'Enquanto Reproduzir Música';

  @override
  String get keepScreenOnWhileLyrics => 'Enquanto Mostrar as Letras';

  @override
  String get keepScreenOnWhilePluggedIn => 'Manter Ecrã Ligado apenas enquanto conectado';

  @override
  String get keepScreenOnWhilePluggedInSubtitle => 'Ignorar a opção de Manter o Ecrã Ligado, se o dispositivo não estiver conectado';

  @override
  String get genericToggleButtonTooltip => 'Pressiona para alternar.';

  @override
  String get artwork => 'Arte';

  @override
  String artworkTooltip(String title) {
    return 'Arte para $title';
  }

  @override
  String playerAlbumArtworkTooltip(String title) {
    return 'Arte para $title. Pressiona para modificar a reprodução. Desliza para a esquerda ou direita para mudar de faixa.';
  }

  @override
  String get nowPlayingBarTooltip => 'Abrir Ecrã de Reprodução';

  @override
  String get additionalPeople => 'Pessoas adicionais';

  @override
  String get playbackMode => 'Modo de reprodução';

  @override
  String get codec => 'Codec';

  @override
  String get bitRate => 'Bit Rate';

  @override
  String get bitDepth => 'Bit Depth';

  @override
  String get size => 'Tamanho';

  @override
  String get normalizationGain => 'Ganho';

  @override
  String get sampleRate => 'Sample Rate';

  @override
  String get showFeatureChipsToggleTitle => 'Mostrar Informação Avançada da Faixa';

  @override
  String get showFeatureChipsToggleSubtitle => 'Mostra informação avançada da faixa: codec, bit rate, e outras no ecrã de reprodução.';

  @override
  String get albumScreen => 'Ecrã do Álbum';

  @override
  String get showCoversOnAlbumScreenTitle => 'Mostrar Capas dos Álbuns nos Temas';

  @override
  String get showCoversOnAlbumScreenSubtitle => 'Mostra as capas dos álbuns em separado para cada faixa no ecrã do álbum.';

  @override
  String get emptyTopTracksList => 'Ainda não ouviste nenhuma faixa deste artista.';

  @override
  String get emptyFilteredListTitle => 'Não foram encontrados itens';

  @override
  String get emptyFilteredListSubtitle => 'Nenhum item corresponde ao filtro. Experimenta desativar o filtro ou alterar a pesquisa.';

  @override
  String get resetFiltersButton => 'Restaurar filtros';

  @override
  String get resetSettingsPromptGlobal => 'Tens a certeza que queres restaurar TODAS as configurações para os valores iniciais?';

  @override
  String get resetSettingsPromptGlobalConfirm => 'Restaurar TODAS as definições';

  @override
  String get resetSettingsPromptLocal => 'Queres restaurar estas definições, de volta aos valores iniciais?';

  @override
  String get genericCancel => 'Cancelar';

  @override
  String itemDeletedSnackbar(String deviceType, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Album',
        'playlist': 'Playlist',
        'artist': 'Artist',
        'genre': 'Genre',
        'track': 'Track',
        'library': 'Library',
        'other': 'Item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deviceType,
      {
        'device': 'Device',
        'server': 'Server',
        'other': 'unknown',
      },
    );
    return '$_temp0 got deleted from $_temp1';
  }

  @override
  String get allowDeleteFromServerTitle => 'Allow deletion from server';

  @override
  String get allowDeleteFromServerSubtitle => 'Enable and disable the option to permanently delete a track from the servers file system when deletion is possible.';

  @override
  String deleteFromTargetDialogText(String deleteType, String device, String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'track': 'track',
        'library': 'library',
        'other': 'item',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      deleteType,
      {
        'canDelete': ' This will also Delete this item from this Device.',
        'cantDelete': ' This item will stay on this device until the next sync.',
        'notDownloaded': '',
        'other': '',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      device,
      {
        'device': 'this device',
        'server': 'the servers file system and library.$_temp1\nThis action cannot be reverted',
        'other': '',
      },
    );
    return 'You are about to delete this $_temp0 from $_temp2.';
  }

  @override
  String deleteFromTargetConfirmButton(String target) {
    String _temp0 = intl.Intl.selectLogic(
      target,
      {
        'device': ' from Device',
        'server': ' from Server',
        'other': '',
      },
    );
    return 'Delete$_temp0';
  }

  @override
  String largeDownloadWarning(int count) {
    return 'Warning: You are about to download $count tracks.';
  }

  @override
  String get downloadSizeWarningCutoff => 'Download Size Warning Cutoff';

  @override
  String get downloadSizeWarningCutoffSubtitle => 'A warning message will be displayed when downloading more than this many tracks at once.';

  @override
  String confirmAddAlbumToPlaylist(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'album',
        'playlist': 'playlist',
        'artist': 'artist',
        'genre': 'genre',
        'other': 'item',
      },
    );
    return 'Are you sure you want add all tracks from $_temp0 \'$itemName\' to this playlist?  They can only be removed individually.';
  }

  @override
  String get publiclyVisiblePlaylist => 'Publicly Visible:';

  @override
  String get releaseDateFormatYear => 'Year';

  @override
  String get releaseDateFormatISO => 'ISO 8601';

  @override
  String get releaseDateFormatMonthYear => 'Month & Year';

  @override
  String get releaseDateFormatMonthDayYear => 'Month, Day & Year';

  @override
  String get showAlbumReleaseDateOnPlayerScreenTitle => 'Show Album Release Date on Player Screen';

  @override
  String get showAlbumReleaseDateOnPlayerScreenSubtitle => 'Show the release date of the album on the player screen, behind the album name.';

  @override
  String get releaseDateFormatTitle => 'Release Date Format';

  @override
  String get releaseDateFormatSubtitle => 'Controls the format of all release dates shown in the app.';

  @override
  String get librarySelectError => 'Error loading available libraries for user';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get finamp => 'Finamp';

  @override
  String get finampTagline => 'Um reprodutor de música de código aberto para Jellyfin';

  @override
  String startupError(String error) {
    return 'Algo deu errado na inicialização. O erro foi: $error\n\nPor favor, crie um problema/issue em github.com/UnicornsOnLSD/finamp anexando uma captura de tela dessa página. Se esse erro persistir, limpe os dados para restaurar o aplicativo.';
  }

  @override
  String get about => 'Sobre Finamp';

  @override
  String get aboutContributionPrompt => 'Feito por pessoas incríveis durante seu tempo livre.\nVocê pode ser uma delas!';

  @override
  String get aboutContributionLink => 'Contribua com o Finamp no Github:';

  @override
  String get aboutReleaseNotes => 'Leia as notas da última versão:';

  @override
  String get aboutTranslations => 'Ajude a traduzir o Finamp para o seu idioma:';

  @override
  String get aboutThanks => 'Obrigado por utilizar o Finamp!';

  @override
  String get loginFlowWelcomeHeading => 'Bem-vindo a';

  @override
  String get loginFlowSlogan => 'Sua música, do seu jeito.';

  @override
  String get loginFlowGetStarted => 'Comece!';

  @override
  String get viewLogs => 'Ver logs';

  @override
  String get changeLanguage => 'Mudar idioma';

  @override
  String get loginFlowServerSelectionHeading => 'Conectar ao Jellyfin';

  @override
  String get back => 'Voltar';

  @override
  String get serverUrl => 'URL do servidor';

  @override
  String get internalExternalIpExplanation => 'Se você deseja acessar seu servidor Jellyfin remotamente, você precisa usar seu IP externo.\n\nSe seu servidor está em uma porta HTTP padrão (80 ou 443), ou na porta padrão do Jellyfin (8096), você não precisa especificar a porta. Se a URL estiver correta, você deverá ver informações sobre o seu servidor aparecerem abaixo do campo de texto.';

  @override
  String get serverUrlHint => 'ex.: demo.jellyfin.org/stable';

  @override
  String get serverUrlInfoButtonTooltip => 'Ajuda relacionada ao URL do servidor';

  @override
  String get emptyServerUrl => 'O campo da URL de servidor não pode ser vazio';

  @override
  String get connectingToServer => 'Conectando-se ao servidor...';

  @override
  String get loginFlowLocalNetworkServers => 'Servidores na sua rede local:';

  @override
  String get loginFlowLocalNetworkServersScanningForServers => 'Procurando por servidores...';

  @override
  String get loginFlowAccountSelectionHeading => 'Selecione a sua conta';

  @override
  String get backToServerSelection => 'Voltar para a seleção de servidor';

  @override
  String get loginFlowNamelessUser => 'Usuário desconhecido';

  @override
  String get loginFlowCustomUser => 'Usuário personalizado';

  @override
  String get loginFlowAuthenticationHeading => 'Entre na sua conta';

  @override
  String get backToAccountSelection => 'Voltar para a seleção de conta';

  @override
  String get loginFlowQuickConnectPrompt => 'Usar código de conexão rápida';

  @override
  String get loginFlowQuickConnectInstructions => 'Abra o aplicativo Jellyfin ou página web, clique no ícone do seu usuário e selecione Conexão Rápida.';

  @override
  String get loginFlowQuickConnectDisabled => 'Conexão rápida está desabilitada nesse servidor.';

  @override
  String get orDivider => 'ou';

  @override
  String get loginFlowSelectAUser => 'Selecionar usuário';

  @override
  String get username => 'Usuário';

  @override
  String get usernameHint => 'Digite seu nome de usuário';

  @override
  String get usernameValidationMissingUsername => 'Por favor digite um nome de usuário';

  @override
  String get password => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get login => 'Entrar';

  @override
  String get logs => 'Registros';

  @override
  String get next => 'Próximo';

  @override
  String get selectMusicLibraries => 'Selecione a biblioteca de músicas';

  @override
  String get couldNotFindLibraries => 'Não foi possível encontrar nenhuma biblioteca.';

  @override
  String get unknownName => 'Nome desconhecido';

  @override
  String get tracks => 'Faixas';

  @override
  String get albums => 'Álbuns';

  @override
  String get artists => 'Artistas';

  @override
  String get genres => 'Gêneros';

  @override
  String get playlists => 'Listas de reprodução';

  @override
  String get startMix => 'Começar mix';

  @override
  String get startMixNoTracksArtist => 'Aperte e segure sobre um artista para adicioná-lo ou removê-lo do criador de mix, antes de começar';

  @override
  String get startMixNoTracksAlbum => 'Aperte e segure sobre um álbum para adicioná-lo ou removê-lo do criador de mix, antes de começar';

  @override
  String get startMixNoTracksGenre => 'Aperte e segure sobre um gênero para adicioná-lo ou removê-lo do criador de mix, antes de começar';

  @override
  String get music => 'Música';

  @override
  String get clear => 'Limpar';

  @override
  String get favourites => 'Favoritos';

  @override
  String get shuffleAll => 'Embaralhar todas';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Configurações';

  @override
  String get offlineMode => 'Modo offline';

  @override
  String get sortOrder => 'Ordenação';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get title => 'Título';

  @override
  String get album => 'Álbum';

  @override
  String get albumArtist => 'Artista do álbum';

  @override
  String get artist => 'Artista';

  @override
  String get budget => 'Orçamento';

  @override
  String get communityRating => 'Avaliação da comunidade';

  @override
  String get criticRating => 'Avaliação dos críticos';

  @override
  String get dateAdded => 'Adicionado em';

  @override
  String get datePlayed => 'Reproduzido em';

  @override
  String get playCount => 'Número de reproduções';

  @override
  String get premiereDate => 'Data de lançamento';

  @override
  String get productionYear => 'Ano de produção';

  @override
  String get name => 'Nome';

  @override
  String get random => 'Aleatório';

  @override
  String get revenue => 'Receita';

  @override
  String get runtime => 'Tempo de execução';

  @override
  String get syncDownloadedPlaylists => 'Sincronizar listas de reprodução baixadas';

  @override
  String get downloadMissingImages => 'Baixar imagens ausentes';

  @override
  String downloadedMissingImages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baixadas $count imagens ausentes',
      one: 'Baixada $count imagem ausente',
      zero: 'Nenhuma imagem ausente baixada',
    );
    return '$_temp0';
  }

  @override
  String get activeDownloads => 'Downloads ativos';

  @override
  String downloadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count baixadas',
      one: '$count baixada',
    );
    return '$_temp0';
  }

  @override
  String downloadedCountUnified(int trackCount, int imageCount, int syncCount, int repairing) {
    String _temp0 = intl.Intl.pluralLogic(
      trackCount,
      locale: localeName,
      other: '$trackCount faixas',
      one: '$trackCount faixa',
    );
    String _temp1 = intl.Intl.pluralLogic(
      imageCount,
      locale: localeName,
      other: '$imageCount imagens',
      one: '$imageCount imagem',
    );
    String _temp2 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      other: '$syncCount nós sincronizados',
      one: '$syncCount nó sincronizado',
    );
    String _temp3 = intl.Intl.pluralLogic(
      repairing,
      locale: localeName,
      other: '\nReparando',
      zero: '',
    );
    return '$_temp0, $_temp1\n$_temp2$_temp3';
  }

  @override
  String dlComplete(int count) {
    return '$count concluídas';
  }

  @override
  String dlFailed(int count) {
    return '$count falharam';
  }

  @override
  String dlEnqueued(int count) {
    return '$count enfileiradas';
  }

  @override
  String dlRunning(int count) {
    return '$count em execução';
  }

  @override
  String get activeDownloadsTitle => 'Downloads ativos';

  @override
  String get noActiveDownloads => 'Nenhum download ativo.';

  @override
  String get errorScreenError => 'Um erro ocorreu durante o acesso à lista de erros! Nesse ponto, você deve criar um chamado (issue) no GitHub e apagar os dados do aplicativo';

  @override
  String get failedToGetTrackFromDownloadId => 'Falha em extrair a faixa do ID da transferência';

  @override
  String get error => 'Erro';

  @override
  String discNumber(int number) {
    return 'Disco $number';
  }

  @override
  String get playButtonLabel => 'Reproduzir';

  @override
  String get shuffleButtonLabel => 'Embaralhar';

  @override
  String trackCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0';
  }

  @override
  String offlineTrackCount(int count, int downloads) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0, $downloads Baixadas';
  }

  @override
  String offlineTrackCountArtist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Faixas',
      one: '$count Faixa',
    );
    return '$_temp0 Baixadas';
  }

  @override
  String get editPlaylistNameTooltip => 'Editar nome da lista de reprodução';

  @override
  String get editPlaylistNameTitle => 'Editar nome da lista de reprodução';

  @override
  String get required => 'Obrigatório';

  @override
  String get updateButtonLabel => 'Atualizar';

  @override
  String get playlistNameUpdated => 'Nome da lista de reprodução atualizado.';

  @override
  String get favourite => 'Favorito';

  @override
  String get downloadsDeleted => 'Transferências apagadas.';

  @override
  String get addDownloads => 'Adicionar transferências';

  @override
  String get location => 'Localização';

  @override
  String get confirmDownloadStarted => 'Transferência iniciada';

  @override
  String get downloadsQueued => 'Transferência adicionada, transferindo os arquivos';

  @override
  String get addButtonLabel => 'Adicionar';

  @override
  String get shareLogs => 'Compartilhar relatórios/logs';

  @override
  String get logsCopied => 'Relatórios/logs copiados.';

  @override
  String get message => 'Mensagem';

  @override
  String get stackTrace => 'Traçado da pilha';

  @override
  String applicationLegalese(String sourceCodeLink) {
    return 'Licenciado com a Mozilla Public License 2.0. \nCódigo-fonte disponível em $sourceCodeLink.';
  }

  @override
  String get transcoding => 'Transcodificando';

  @override
  String get downloadLocations => 'Locais de transferências';

  @override
  String get audioService => 'Serviço de áudio';

  @override
  String get interactions => 'Interações';

  @override
  String get layoutAndTheme => 'Composição & Tema';

  @override
  String get notAvailableInOfflineMode => 'Não disponível no modo offline';

  @override
  String get logOut => 'Sair';

  @override
  String get downloadedTracksWillNotBeDeleted => 'Faixas transferidas não serão apagadas';

  @override
  String get areYouSure => 'Tem certeza?';

  @override
  String get jellyfinUsesAACForTranscoding => 'Jellyfin usa AAC para transcodificação';

  @override
  String get enableTranscoding => 'Ativar transcodificação';

  @override
  String get enableTranscodingSubtitle => 'A transmissão de músicas será transcodificada pelo servidor.';

  @override
  String get bitrate => 'Taxa de bits';

  @override
  String get bitrateSubtitle => 'Uma taxa de bits mais alta resulta em um áudio de maior qualidade, com um custo maior de largura de banda.';

  @override
  String get customLocation => 'Localização customizada';

  @override
  String get appDirectory => 'Diretório de aplicativo';

  @override
  String get addDownloadLocation => 'Adicionar local de transferências';

  @override
  String get selectDirectory => 'Selecionar diretório';

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get pathReturnSlashErrorMessage => 'Caminhos que retornam \"/\" não podem ser usados';

  @override
  String get directoryMustBeEmpty => 'O diretório deve estar vazio';

  @override
  String get customLocationsBuggy => 'Localizações customizadas são inconsistentes devido a problemas com permissões. Estou pensando em maneiras de solucionar isso, mas por enquanto eu não recomendaria que fossem utilizadas.';

  @override
  String get enterLowPriorityStateOnPause => 'Entrar em modo de baixa prioridade durante pausa';

  @override
  String get enterLowPriorityStateOnPauseSubtitle => 'Quando em pausa, possibilita que a notificação seja descartada e permite ao Android terminar o serviço.';

  @override
  String get shuffleAllTrackCount => 'Contagem de faixas da função embaralhar todas';

  @override
  String get shuffleAllTrackCountSubtitle => 'Quantidade de faixas para carregar ao utilizar o botão misturar todas as faixas.';

  @override
  String get viewType => 'Tipo de visualização';

  @override
  String get viewTypeSubtitle => 'Tipo de visualização para a tela de música';

  @override
  String get list => 'Lista';

  @override
  String get grid => 'Grade';

  @override
  String get customizationSettingsTitle => 'Customização';

  @override
  String get playbackSpeedControlSetting => 'Visibilidade da velocidade de reprodução';

  @override
  String get playbackSpeedControlSettingSubtitle => 'Indica se os controles de velocidade de reprodução são exibidos no menu do reprodutor';

  @override
  String playbackSpeedControlSettingDescription(int trackDuration, int albumDuration, String genreList) {
    return 'Automático:\nFinamp tenta identificar se a faixa que está sendo executada é um podcat ou (parte de) um áudio-livro. Esse é considerado o caso se: a duração da faixa é superior a $trackDuration minutos, se o álbum ao qual pertence a faixa tem duração superior a $albumDuration horas, ou se a faixa tem pelo menos um desses gêneros atribuídos a ela ($genreList).\nOs controles de velocidade de reprodução serão então exibidos no menu do reprodutor.\n\nSempre exibir:\nOs controles de velocidade de reprodução serão sempre exibidos no menu do reprodutor.\n\nOcultado:\nOs controles de velocidade de reprodução serão sempre ocultados.';
  }

  @override
  String get automatic => 'Automático';

  @override
  String get shown => 'Sempre exibir';

  @override
  String get hidden => 'Ocultado';

  @override
  String get speed => 'Velocidade';

  @override
  String get reset => 'Resetar';

  @override
  String get apply => 'Aplicar';

  @override
  String get portrait => 'Retrato';

  @override
  String get landscape => 'Paisagem';

  @override
  String gridCrossAxisCount(String value) {
    return '$value Contagem de eixo cruzado da grade';
  }

  @override
  String gridCrossAxisCountSubtitle(String value) {
    return 'Quantidade de ícones de grade a serem utilizados por linha quando $value.';
  }

  @override
  String get showTextOnGridView => 'Mostrar texto na visualização em grade';

  @override
  String get showTextOnGridViewSubtitle => 'Exibir ou não o texto (título, artista, etc) na grade da tela de música.';

  @override
  String get useCoverAsBackground => 'Utilizar capas desfocadas como plano de fundo';

  @override
  String get useCoverAsBackgroundSubtitle => 'Utilizar ou não a arte das capas dos álbuns desfocadas como plano de fundo do reprodutor.';

  @override
  String get playerScreenMinimumCoverPaddingEditorTitle => 'Preenchimento mínimo para a capa do álbum';

  @override
  String get playerScreenMinimumCoverPaddingEditorSubtitle => 'Preenchimento mínimo da tela em torno da capa do álbum (em % da largura da tela).';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtists => 'Esconder o nome dos artistas da faixa se forem os mesmos nomes dos artistas do álbum';

  @override
  String get hideTrackArtistsIfSameAsAlbumArtistsSubtitle => 'Indica se os nomes dos artistas da faixa devem ser exibidos na tela do álbum se não forem diferentes dos nomes dos artistas do álbum.';

  @override
  String get showArtistsTopTracks => 'Exibir faixas mais tocadas na tela do artista';

  @override
  String get showArtistsTopTracksSubtitle => 'Indica se as 5 faixas mais reproduzidas de um artista devem ser exibidas.';

  @override
  String get disableGesture => 'Desativar gestos';

  @override
  String get disableGestureSubtitle => 'Indica se os gestos devem ser desativados.';

  @override
  String get showFastScroller => 'Mostrar rolagem rápida';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get tabs => 'Abas';

  @override
  String get playerScreen => 'Tela do reprodutor';

  @override
  String get cancelSleepTimer => 'Cancelar o temporizador de sono?';

  @override
  String get yesButtonLabel => 'Sim';

  @override
  String get noButtonLabel => 'Não';

  @override
  String get setSleepTimer => 'Configurar o temporizador de sono';

  @override
  String get hours => 'Horas';

  @override
  String get seconds => 'Segundos';

  @override
  String get minutes => 'Minutos';

  @override
  String timeFractionTooltip(Object currentTime, Object totalTime) {
    return '$currentTime de $totalTime';
  }

  @override
  String trackCountTooltip(int currentTrackIndex, int totalTrackCount) {
    return 'Faixa $currentTrackIndex de $totalTrackCount';
  }

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get sleepTimerTooltip => 'Temporizador de sono';

  @override
  String sleepTimerRemainingTime(int time) {
    return 'Suspendendo em $time minutos';
  }

  @override
  String get addToPlaylistTooltip => 'Adicionar à lista de reprodução';

  @override
  String get addToPlaylistTitle => 'Adicionar à lista de reprodução';

  @override
  String get addToMorePlaylistsTooltip => 'Adicionar a mais listas de reprodução';

  @override
  String get addToMorePlaylistsTitle => 'Adicionar a mais listas de reprodução';

  @override
  String get removeFromPlaylistTooltip => 'Remover dessa lista de reprodução';

  @override
  String get removeFromPlaylistTitle => 'Remover dessa lista de reprodução';

  @override
  String removeFromPlaylistNamedTooltip(String playlistName) {
    return 'Remover da lista de reprodução \'$playlistName\'';
  }

  @override
  String removeFromPlaylistNamedTitle(String playlistName) {
    return 'Remover da lista de reprodução \'$playlistName\'';
  }

  @override
  String get newPlaylist => 'Nova lista de reprodução';

  @override
  String get createButtonLabel => 'Criar';

  @override
  String get playlistCreated => 'Lista de reprodução criada.';

  @override
  String get playlistActionsMenuButtonTooltip => 'Pressione para adicionar à lista de reprodução. Pressione por mais tempo para marcar como favorito.';

  @override
  String get noAlbum => 'Nenhum álbum';

  @override
  String get noItem => 'Nenhum ítem';

  @override
  String get noArtist => 'Nenhum artista';

  @override
  String get unknownArtist => 'Artista desconhecido';

  @override
  String get unknownAlbum => 'Álbum desconhecido';

  @override
  String get playbackModeDirectPlaying => 'Reprodução direta';

  @override
  String get playbackModeTranscoding => 'Transcodificando';

  @override
  String kiloBitsPerSecondLabel(int bitrate) {
    return '$bitrate kbps';
  }

  @override
  String get playbackModeLocal => 'Reproduzindo localmente';

  @override
  String get queue => 'Fila';

  @override
  String get addToQueue => 'Adicionar à fila';

  @override
  String get replaceQueue => 'Troca fila';

  @override
  String get instantMix => 'Mistura Instantânea';

  @override
  String get goToAlbum => 'Ir para álbum';

  @override
  String get goToArtist => 'Ir para artista';

  @override
  String get goToGenre => 'Ir para gênero';

  @override
  String get removeFavourite => 'Remover dos favoritos';

  @override
  String get addFavourite => 'Adicionar aos favoritos';

  @override
  String get confirmFavoriteAdded => 'Adicionado aos favoritos';

  @override
  String get confirmFavoriteRemoved => 'Removido dos favoritos';

  @override
  String get addedToQueue => 'Adicionado à fila.';

  @override
  String get insertedIntoQueue => 'Inserido na fila.';

  @override
  String get queueReplaced => 'Fila substituída.';

  @override
  String get confirmAddedToPlaylist => 'Adicionado à lista de reprodução.';

  @override
  String get removedFromPlaylist => 'Removido da lista de reprodução.';

  @override
  String get startingInstantMix => 'Iniciando mistura instantânea.';

  @override
  String get anErrorHasOccured => 'Ocorreu um erro.';

  @override
  String responseError(String error, int statusCode) {
    return '$error Código de condição $statusCode.';
  }

  @override
  String responseError401(String error, int statusCode) {
    return '$error Código de condição $statusCode. Isso provavelmente significa que você usou um nome de usuário/senha errado, ou que seu cliente não está mais autenticado.';
  }

  @override
  String get removeFromMix => 'Remover do mix';

  @override
  String get addToMix => 'Adicionar ao mix';

  @override
  String redownloadedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens foram baixados novamente',
      one: '$count item foi baixado novamente',
      zero: 'Sem necessidade de baixar novamente.',
    );
    return '$_temp0';
  }

  @override
  String get bufferDuration => 'Duração do buffer';

  @override
  String get bufferDurationSubtitle => 'A máxima duração que deve ser armazenada em buffer, em segundos. Requer reinicialização.';

  @override
  String get bufferDisableSizeConstraintsTitle => 'Não limitar tamanho do buffer';

  @override
  String get bufferDisableSizeConstraintsSubtitle => 'Desabilita as restrições de tamanho do buffer (\"Tamanho do buffer\"). O buffer sempre será carregado de acordo com a duração configurada (\"Duração do buffer\"), mesmo para arquivos muito grandes. Pode causar travamentos. Requer reinicialização.';

  @override
  String get bufferSizeTitle => 'Tamanho do buffer';

  @override
  String get bufferSizeSubtitle => 'O máximo tamanho do buffer em MB. Requer reinicialização';

  @override
  String get language => 'Idioma';

  @override
  String get skipToPreviousTrackButtonTooltip => 'Pular para o início ou para a faixa anterior';

  @override
  String get skipToNextTrackButtonTooltip => 'Pular para a próxima faixa';

  @override
  String get togglePlaybackButtonTooltip => 'Alternar a reprodução';

  @override
  String get previousTracks => 'Faixas anteriores';

  @override
  String get nextUp => 'A seguir';

  @override
  String get clearNextUp => 'Limpar próximo da fila';

  @override
  String get playingFrom => 'Reproduzindo de';

  @override
  String get playNext => 'Reproduzir próximo';

  @override
  String get addToNextUp => 'Adicionar às próximas';

  @override
  String get shuffleNext => 'Adicionar aleatório ao topo das próximas';

  @override
  String get shuffleToNextUp => 'Adicionar aleatório ao final das próximas';

  @override
  String get shuffleToQueue => 'Adicionar aleatório ao final da fila';

  @override
  String confirmPlayNext(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Faixa',
        'album': 'Álbum',
        'artist': 'Artista',
        'playlist': 'Lista de reprodução',
        'genre': 'Gênero',
        'other': 'Item',
      },
    );
    return '$_temp0 vai tocar em seguida';
  }

  @override
  String confirmAddToNextUp(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Faixa adicionada',
        'album': 'Álbum adicionado',
        'artist': 'Artista adicionado',
        'playlist': 'Lista de reprodução adicionada',
        'genre': 'Gênero adicionado',
        'other': 'item',
      },
    );
    return '$_temp0 às próximas';
  }

  @override
  String confirmAddToQueue(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'track': 'Faixa adicionada',
        'album': 'Álbum adicionado',
        'artist': 'Artista adicionado',
        'playlist': 'Lista de reprodução adicionada',
        'genre': 'Gênero adicionado',
        'other': 'item',
      },
    );
    return '$_temp0 à fila';
  }

  @override
  String get confirmShuffleNext => 'Adicionado aletoriamente ao topo das próximas';

  @override
  String get confirmShuffleToNextUp => 'Adicionado aletoriamente ao final das próximas';

  @override
  String get confirmShuffleToQueue => 'Adicionado aletoriamente ao final da fila';

  @override
  String get placeholderSource => 'Algum lugar';

  @override
  String get playbackHistory => 'Histórico de reprodução';

  @override
  String get shareOfflineListens => 'Compartilhar reproduções offline';

  @override
  String get yourLikes => 'Seus likes';

  @override
  String mix(String mixSource) {
    return '$mixSource - Mix';
  }

  @override
  String get tracksFormerNextUp => 'Faixas adicionadas via próximas';

  @override
  String get savedQueue => 'Fila salva';

  @override
  String playingFromType(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'do álbum',
        'playlist': 'da lista de reprodução',
        'trackMix': 'do mix de faixas',
        'artistMix': 'do mix do artista',
        'albumMix': 'do mix do álbum',
        'genreMix': 'do mix do gênero',
        'favorites': 'dos favoritos',
        'allTracks': 'de todas as faixas',
        'filteredList': 'das faixas',
        'genre': 'do gênero',
        'artist': 'do artista',
        'track': 'faixa',
        'nextUpAlbum': 'do álbum das próximas',
        'nextUpPlaylist': 'da lista de reprodução das próximas',
        'nextUpArtist': 'do artista das próximas',
        'other': '',
      },
    );
    return 'Reproduzindo $_temp0';
  }

  @override
  String get shuffleAllQueueSource => 'Embaralhar todas';

  @override
  String get playbackOrderLinearButtonLabel => 'Reproduzindo na ordem';

  @override
  String get playbackOrderLinearButtonTooltip => 'Reproduzindo na ordem. Pressione para embaralhar.';

  @override
  String get playbackOrderShuffledButtonLabel => 'Embaralhando faixas';

  @override
  String get playbackOrderShuffledButtonTooltip => 'Embaralhando faixas. Pressione para reproduzir na ordem.';

  @override
  String playbackSpeedButtonLabel(double speed) {
    return 'Reproduzindo na velocidade ${speed}x';
  }

  @override
  String playbackSpeedFeatureText(double speed) {
    return 'velocidade ${speed}x';
  }

  @override
  String get playbackSpeedDecreaseLabel => 'Reduzir velocidade de reprodução';

  @override
  String get playbackSpeedIncreaseLabel => 'Aumentar velocidade de reprodução';

  @override
  String get loopModeNoneButtonLabel => 'Sem repetição';

  @override
  String get loopModeOneButtonLabel => 'Repetindo essa faixa';

  @override
  String get loopModeAllButtonLabel => 'Repetindo todas';

  @override
  String get queuesScreen => 'Restaurar fila tocando agora';

  @override
  String get queueRestoreButtonLabel => 'Restaurar';

  @override
  String queueRestoreTitle(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat('yyy-MM-dd hh:mm', localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Salvo $dateString';
  }

  @override
  String queueRestoreSubtitle1(String track) {
    return 'Reproduzindo: $track';
  }

  @override
  String queueRestoreSubtitle2(int count, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faixas',
      one: '1 faixa',
    );
    return '$_temp0, $remaining restantes';
  }

  @override
  String get queueLoadingMessage => 'Restaurando fila...';

  @override
  String get queueRetryMessage => 'Falha ao restaurar a fila. Tentar novamente?';

  @override
  String get autoloadLastQueueOnStartup => 'Auto-restaurar a última fila';

  @override
  String get autoloadLastQueueOnStartupSubtitle => 'Tentar restaurar a lista das últimas reproduzidas durante a inicialização da aplicação.';

  @override
  String get reportQueueToServer => 'Reportar a fila atual para o servidor?';

  @override
  String get reportQueueToServerSubtitle => 'Quando habilitado, Finamp irá enviar a fila atual para o servidor. Atualmente parece haver pouco uso para essa função, além de ela contribuir para um aumento no tráfego da rede.';

  @override
  String get periodicPlaybackSessionUpdateFrequency => 'Taxa de atualização da sessão de reprodução';

  @override
  String get periodicPlaybackSessionUpdateFrequencySubtitle => 'Frequência em que se deseja enviar o atual estado de reprodução para o servidor, em segundos. Deve ser inferior a 5 minutos (300 segundos), de forma a evitar que a sessão expire.';

  @override
  String get periodicPlaybackSessionUpdateFrequencyDetails => 'Se o servidor Jellyfin não receber atualizações de um cliente durante os últimos 5 minutos, ele assumirá que a reprodução foi concluída. Isso significa que para faixas com duração superior a 5 minutos ,a reprodução poderá ser erroneamente reportada como finalizada, o que reduzirá a qualidade dos dados dos relatórios de reprodução.';

  @override
  String get topTracks => 'Faixas mais tocadas';

  @override
  String albumCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Álbuns',
      one: '$count Álbum',
    );
    return '$_temp0';
  }

  @override
  String get shuffleAlbums => 'Embaralhar álbuns';

  @override
  String get shuffleAlbumsNext => 'Embaralhar álbuns no topo das próximas';

  @override
  String get shuffleAlbumsToNextUp => 'Embaralhar álbuns ao final das próximas';

  @override
  String get shuffleAlbumsToQueue => 'Embaralhar álbuns ao final da fila';

  @override
  String playCountValue(int playCount) {
    String _temp0 = intl.Intl.pluralLogic(
      playCount,
      locale: localeName,
      other: '$playCount reproduzidos',
      one: '$playCount reproduzido',
    );
    return '$_temp0';
  }

  @override
  String couldNotLoad(String source) {
    String _temp0 = intl.Intl.selectLogic(
      source,
      {
        'album': 'álbum',
        'playlist': 'lista de reprodução',
        'trackMix': 'mix de faixas',
        'artistMix': 'mix de artista',
        'albumMix': 'mix de álbum',
        'genreMix': 'mix de gênero',
        'favorites': 'favoritos',
        'allTracks': 'todas as faixas',
        'filteredList': 'faixas',
        'genre': 'gênero',
        'artist': 'artista',
        'track': 'faixa',
        'nextUpAlbum': 'álbum nas próximas',
        'nextUpPlaylist': 'lista de reprodução nas próximas',
        'nextUpArtist': 'artista nas próximas',
        'other': '',
      },
    );
    return 'Não foi possível carregar $_temp0';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get close => 'Fechar';

  @override
  String get showUncensoredLogMessage => 'Este registro contém suas credenciais de acesso. Revelar?';

  @override
  String get resetTabs => 'Redefinir abas';

  @override
  String get resetToDefaults => 'Retornar para configurações padrão';

  @override
  String get noMusicLibrariesTitle => 'Sem Bibliotecas de Música';

  @override
  String get noMusicLibrariesBody => 'O Finamp não conseguiu encontrar nenhuma biblioteca de música. Certifique-se de que o seu servidor Jellyfin tenha pelo menos uma biblioteca com o tipo de conteúdo definido como \"Música\".';

  @override
  String get refresh => 'Atualizar';

  @override
  String get moreInfo => 'Mais informações';

  @override
  String get volumeNormalizationSettingsTitle => 'Normalização de volume';

  @override
  String get volumeNormalizationSwitchTitle => 'Habilitar normalização de volume';

  @override
  String get volumeNormalizationSwitchSubtitle => 'Utilizar informação do ganho para normalizar o volume das faixas (\"Replay Gain\")';

  @override
  String get volumeNormalizationModeSelectorTitle => 'Modo de normalização de volume';

  @override
  String get volumeNormalizationModeSelectorSubtitle => 'Quando e como aplicar a normalização de volume';

  @override
  String get volumeNormalizationModeSelectorDescription => 'Híbrido (Faixa + Álbum):\nGanho de faixa é utilizado para a reprodução regular, porém se um álbum estiver sendo reproduzido (por ser a principal fonte da lista de reprodução, ou por ter sido adicionado à fila em determinado ponto), o ganho do álbuns será priorizado.\n\nBaseado em faixa:\nGanho de faixa é sempre utilizado, independentemente de um álbum estar ou não em reprodução.\n\nApenas álbuns:\nNormalização de volume somente é aplicada quando houver álbuns em reprodução (utilizando o ganho de álbum). Não é aplicada durante a reprodução de faixas individuais.';

  @override
  String get volumeNormalizationModeHybrid => 'Híbrido (Faixa + Álbum)';

  @override
  String get volumeNormalizationModeTrackBased => 'Baseado em faixa';

  @override
  String get volumeNormalizationModeAlbumBased => 'Baseado em álbum';

  @override
  String get volumeNormalizationModeAlbumOnly => 'Apenas para álbuns';

  @override
  String get volumeNormalizationIOSBaseGainEditorTitle => 'Ganho base';

  @override
  String get volumeNormalizationIOSBaseGainEditorSubtitle => 'Atualmente, a normalização de volume no iOS requer que o volume de reprodução seja alterado de forma a emular a alteração de ganho. Já que não é possível incrementar o volume acima de 100%, há a necessidade de reduzir o volume por padrão, de forma que seja possível aumentá-lo durante a reprodução de faixas mais suaves. O valor está em decibel (dB), onde -10 dB representa em torno de 30% do volume, -4.5 dB em torno de 60% do volume e -2 dB em torno de 80% do volume.';

  @override
  String numberAsDecibel(double value) {
    return '$value dB';
  }

  @override
  String get swipeInsertQueueNext => 'Tocar faixa deslizada em seguida';

  @override
  String get swipeInsertQueueNextSubtitle => 'Habilita a adição de uma faixa como próximo item na lista quando ela for deslizada, ao invés de adicioná-la ao final.';

  @override
  String get startInstantMixForIndividualTracksSwitchTitle => 'Iniciar mix instantâneos para faixas individuais';

  @override
  String get startInstantMixForIndividualTracksSwitchSubtitle => 'Quando habilitado, tocar em uma faixa na aba de faixas irá iniciar um mix instantâneo daquela faixa, ao invés de reproduzir apenas uma faixa.';

  @override
  String get downloadItem => 'Transferir';

  @override
  String get repairComplete => 'Reparo de transferências concluído.';

  @override
  String get syncComplete => 'Todas as transferências foram ressincronizadas.';

  @override
  String get syncDownloads => 'Sincronizar e baixar itens faltantes.';

  @override
  String get repairDownloads => 'Reparar problemas com arquivos transferidos ou metadados.';

  @override
  String get requireWifiForDownloads => 'Exigir WiFi para transferências.';

  @override
  String queueRestoreError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faixas não puderam ser restauradas na fila',
      one: '$count faixa não pode ser restaurada na fila',
    );
    return 'Atenção: $_temp0.';
  }

  @override
  String activeDownloadsListHeader(String typeName, int itemCount) {
    String _temp0 = intl.Intl.selectLogic(
      typeName,
      {
        'downloading': 'Executando',
        'failed': 'Falhou',
        'syncFailed': 'Repetidamente não sincronizado',
        'enqueued': 'Enfileirado',
        'other': '',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Transferências',
      one: 'Transferência',
    );
    return '$itemCount $_temp0 $_temp1';
  }

  @override
  String downloadLibraryPrompt(String libraryName) {
    return 'Você tem certeza que deseja transferir todo o conteúdo da biblioteca \'\'$libraryName\'\'?';
  }

  @override
  String get onlyShowFullyDownloaded => 'Mostrar apenas álbuns com transferência concluída';

  @override
  String get filesystemFull => 'Transferências restantes não puderam ser completadas. O sistema de arquivos está cheio.';

  @override
  String get connectionInterrupted => 'Conexão interrompida, pausando transferências.';

  @override
  String get connectionInterruptedBackground => 'A conexão foi interrompida enquanto havia transferências em segundo plano. Isso pode ser causado por configurações do sistema operacional.';

  @override
  String get connectionInterruptedBackgroundAndroid => 'A conexão foi interrompida enquanto havia transferências em segundo plano. Isso pode ser causado pela habilitação da função \"Entrar em estado de baixa prioridade em pausa\" ou configurações do sistema operacional.';

  @override
  String get activeDownloadSize => 'Transferindo...';

  @override
  String get missingDownloadSize => 'Apagando...';

  @override
  String get syncingDownloadSize => 'Sincronizando...';

  @override
  String get runRepairWarning => 'O servidor não pode ser contatado para finalização da migração de transferências. Por favor, execute \"Reparar transferências\" na tela de transferências assim que a conexão for reestabelecida.';

  @override
  String get downloadSettings => 'Transferindo configurações';

  @override
  String get showNullLibraryItemsTitle => 'Mostar mídia com biblioteca desconhecida.';

  @override
  String get showNullLibraryItemsSubtitle => 'Algumas mídias podem ser transferidas com bibliotecas desconhecidas. Desabilite para ocultá-las fora de sua coleção original.';

  @override
  String get maxConcurrentDownloads => 'Número máximo de transferências em paralelo';

  @override
  String get maxConcurrentDownloadsSubtitle => 'Aumentar o número de transferências em paralelo aumenta o número de transferências em segundo plano, porém pode causar falhas no caso de transferências muito grandes, ou causar lentidão excessiva em alguns casos.';

  @override
  String maxConcurrentDownloadsLabel(String count) {
    return '$count transferências em paralelo';
  }

  @override
  String get downloadsWorkersSetting => 'Número de gerenciadores de transferência';

  @override
  String get downloadsWorkersSettingSubtitle => 'Número de gerenciadores de transferência para sincronizar metadados e apagar transferências. Aumentar a quantidade de gerenciadores pode aumentar a velocidade de sincronização e exclusão de transferências, especialemente quando a latência do servidor for elevada, porém pode introduzir lentidão.';

  @override
  String downloadsWorkersSettingLabel(String count) {
    return '$count gerenciadores de transferência';
  }

  @override
  String get syncOnStartupSwitch => 'Sincronizar transferências automaticamente durante a inicialização';

  @override
  String get preferQuickSyncSwitch => 'Peferir sincronização rápida';

  @override
  String get preferQuickSyncSwitchSubtitle => 'Ao executar sincronizações, alguns itens tipicamente estáticos, como faixas e álbuns, não serão atualizados. A reparação de transferência sempre executará um sincronismo completo.';

  @override
  String itemTypeSubtitle(String itemType, String itemName) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'album': 'Álbum',
        'playlist': 'Lista de reprodução',
        'artist': 'Artista',
        'genre': 'Gênero',
        'track': 'Faixa',
        'library': 'Biblioteca',
        'unknown': 'Item',
        'other': '$itemType',
      },
    );
    return '$_temp0 $itemName';
  }

  @override
  String incidentalDownloadTooltip(String parentName) {
    return '$parentName requer que esse ítem seja transferido.';
  }

  @override
  String finampCollectionNames(String itemType) {
    String _temp0 = intl.Intl.selectLogic(
      itemType,
      {
        'favorites': 'Favoritos',
        'allPlaylists': 'Todas as listas de reprodução',
        'fiveLatestAlbums': '5 álbuns mais recentes',
        'allPlaylistsMetadata': 'Metadados da lista de reprodução',
        'other': '$itemType',
      },
    );
    return '$_temp0';
  }

  @override
  String cacheLibraryImagesName(String libraryName) {
    return 'Imagens em cache para \'$libraryName\'';
  }

  @override
  String get transcodingStreamingContainerTitle => 'Selecionar contêiner de transcodificação';

  @override
  String get transcodingStreamingContainerSubtitle => 'Selecione o contêiner de segmento a ser usado ao transmitir áudio transcodificado. As faixas que já estejam na fila não serão afetadas.';

  @override
  String get downloadTranscodeEnableTitle => 'Habilitar transferências transcodificadas';

  @override
  String get downloadTranscodeCodecTitle => 'Selecione o codec a ser utilizado para transferências';

  @override
  String downloadTranscodeEnableOption(String option) {
    String _temp0 = intl.Intl.selectLogic(
      option,
      {
        'always': 'Sempre',
        'never': 'Nunca',
        'ask': 'Perguntar',
        'other': '$option',
      },
    );
    return '$_temp0';
  }

  @override
  String get downloadBitrate => 'Bitrate das transferências';

  @override
  String get downloadBitrateSubtitle => 'Um valor mais alto de bitrate fornece maior qualidade de áudio, com um custo maior de armazenamento.';

  @override
  String get transcodeHint => 'Transcodificar?';

  @override
  String doTranscode(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'null': '',
        'other': ' - ~$size',
      },
    );
    return 'Transferir como $codec @ $bitrate$_temp0';
  }

  @override
  String downloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      bitrate,
      {
        'null': '',
        'other': ' @ $bitrate transcodificado',
      },
    );
    return '$size $codec$_temp0';
  }

  @override
  String collectionDownloadInfo(String bitrate, String codec, String size) {
    String _temp0 = intl.Intl.selectLogic(
      codec,
      {
        'ORIGINAL': '',
        'other': ' como $codec @ $bitrate',
      },
    );
    return '$size$_temp0';
  }

  @override
  String dontTranscode(String description) {
    String _temp0 = intl.Intl.selectLogic(
      description,
      {
        'null': '',
        'other': ' - $description',
      },
    );
    return 'Transferir original$_temp0';
  }

  @override
  String get redownloadcomplete => 'Retranscodificação de transferências enfileiradas.';

  @override
  String get redownloadTitle => 'Retranscodificar transferências automaticamente';

  @override
  String get redownloadSubtitle => 'Retransfere automaticamente faixas que estejam em qualidade divergente devido a alterações na coleção principal.';

  @override
  String get defaultDownloadLocationButton => 'Define como local padrão para transferências. Desabilita a seleção individual por transferência.';

  @override
  String get fixedGridSizeSwitchTitle => 'Usar blocos de tamanho fixo para a grade';

  @override
  String get fixedGridSizeSwitchSubtitle => 'Os blocos da grade não serão afetados pelo tamanho da tela/janela.';

  @override
  String get fixedGridSizeTitle => 'Tamanho do bloco da grade';

  @override
  String fixedGridTileSizeEnum(String size) {
    String _temp0 = intl.Intl.selectLogic(
      size,
      {
        'small': 'Pequeno',
        'medium': 'Médio',
        'large': 'Grande',
        'veryLarge': 'Muito grande',
        'other': '???',
      },
    );
    return '$_temp0';
  }

  @override
  String get allowSplitScreenTitle => 'Permitir modo de divisão de tela';

  @override
  String get allowSplitScreenSubtitle => 'O reprodutor será exibido ao lado de outras janelas em telas mais largas.';

  @override
  String get enableVibration => 'Habilitar vibração';

  @override
  String get enableVibrationSubtitle => 'Habilitar/desabilitar vibração.';

  @override
  String get hidePlayerBottomActions => 'Ocultar botões';

  @override
  String get hidePlayerBottomActionsSubtitle => 'Ocultar os botões de fila e letras na tela do reprodutor. Deslizar para cima para acessar a fila, deslizar para a esquerda (abaixo da capa do álbum) para visualizar as letras, se disponíveis.';

  @override
  String get prioritizePlayerCover => 'Priorizar capa do álbum';

  @override
  String get prioritizePlayerCoverSubtitle => 'Prioriza a exibição mais ampla da capa do ábum na tela do reprodudor. Controles não críticos serão ocultados de maneira mais agressiva em telas de menor tamanho.';

  @override
  String get suppressPlayerPadding => 'Suprimir espaçamento dos controles do reprodutor';

  @override
  String get suppressPlayerPaddingSubtitle => 'Minimiza o espaçamento entre os controles do reprodutor quando a capa do álbum não entá em tamanho integral.';

  @override
  String get lockDownload => 'Sempre manter no dispositivo';

  @override
  String get showArtistChipImage => 'Mostrar imagens do artista juntamente com nome';

  @override
  String get showArtistChipImageSubtitle => 'Afeta a visualização de imagens pequenas de artistas, como na tela do reprodutor.';

  @override
  String get scrollToCurrentTrack => 'Ir para a faixa atual';

  @override
  String get enableAutoScroll => 'Habiliar rolagem automática';

  @override
  String numberAsKiloHertz(double kiloHertz) {
    return '$kiloHertz kHz';
  }

  @override
  String numberAsBit(int bit) {
    return '$bit bit';
  }

  @override
  String remainingDuration(String duration) {
    return '$duration restante';
  }

  @override
  String get removeFromPlaylistConfirm => 'Remover';

  @override
  String removeFromPlaylistPrompt(String itemName, String playlistName) {
    return 'Remover \'$itemName\' da lista de reprodução \'$playlistName\'?';
  }

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get addRemoveFromPlaylist => 'Adicionar/remover das listas de reprodução';

  @override
  String get addPlaylistSubheader => 'Adicionar faixa à lista de reprodução';

  @override
  String get trackOfflineFavorites => 'Sincronizar todas as informações de favoritos';

  @override
  String get trackOfflineFavoritesSubtitle => 'Permite exibir informações mais atualizadas dos favoritos em modo offline. Não transfere nenhum arquivo adicional.';

  @override
  String get allPlaylistsInfoSetting => 'Transferir metadados da lista de reprodução';

  @override
  String get allPlaylistsInfoSettingSubtitle => 'Sincroniza metadados de todas as listas de reprodução visando melhora da experiência';

  @override
  String get downloadFavoritesSetting => 'Transferir todos os favoritos';

  @override
  String get downloadAllPlaylistsSetting => 'Transferir todas as listas de reprodução';

  @override
  String get fiveLatestAlbumsSetting => 'Transferir os 5 álbuns mais recentes';

  @override
  String get fiveLatestAlbumsSettingSubtitle => 'Transferências serão removidas à medida que envelhecem. Bloqueia a transferência de forma a previnir que o álbum seja removido.';

  @override
  String get cacheLibraryImagesSettings => 'Colocar em cache imagens da biblioteca atual';

  @override
  String get cacheLibraryImagesSettingsSubtitle => 'Todas as capas de álbum, artista, gênero e lista de reprodução da atual biblioteca serão transferidos.';

  @override
  String get showProgressOnNowPlayingBarTitle => 'Exibir progresso da faixa no mini reprodutor';
}
