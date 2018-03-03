﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы с включенными профилями безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Функции-конструкторы разрешений.
//

// Возвращает внутреннее описание разрешения на использование каталога файловой системы.
//
// Параметры:
//  Адрес - Строка - адрес ресурса файловой системы,
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из данного каталога файловой системы,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в указанный каталог файловой системы,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаФайловойСистемы(Знач Адрес, Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "FileSystemAccess"));
	Результат.Description = Описание;
	
	Если СтрЗаканчиваетсяНа(Адрес, "\") Или СтрЗаканчиваетсяНа(Адрес, "/") Тогда
		Адрес = Лев(Адрес, СтрДлина(Адрес) - 1);
	КонецЕсли;
	
	Результат.Path = Адрес;
	Результат.AllowedRead = ЧтениеДанных;
	Результат.AllowedWrite = ЗаписьДанных;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование каталога временных файлов.
//
// Параметры:
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из каталога временных файлов,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в каталог временных файлов,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаВременныхФайлов(Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Возврат РазрешениеНаИспользованиеКаталогаФайловойСистемы(ПсевдонимКаталогаВременныхФайлов(), ЧтениеДанных, ЗаписьДанных);
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование каталога программы.
//
// Параметры:
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из каталога программы,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в каталог программы,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаПрограммы(Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Возврат РазрешениеНаИспользованиеКаталогаФайловойСистемы(ПсевдонимКаталогаПрограммы(), ЧтениеДанных, ЗаписьДанных);
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование COM-класса.
//
// Параметры:
//  ProgID - Строка - ProgID класса COM, с которым он зарегистрирован в системе.
//    Например, "Excel.Application",
//  CLSID - Строка - CLSID класса COM, с которым он зарегистрирован в системе.
//  ИмяКомпьютера - Строка - имя компьютера, на котором надо создать указанный объект.
//    Если параметр опущен - объект будет создан на компьютере, на котором выполняется
//    текущий рабочий процесс,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаСозданиеCOMКласса(Знач ProgID, Знач CLSID, Знач ИмяКомпьютера = "", Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "CreateComObject"));
	Результат.Description = Описание;
	
	Результат.ProgId = ProgID;
	Результат.CLSID = Строка(CLSID);
	Результат.ComputerName = ИмяКомпьютера;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование внешней компоненты, поставляемой
//  в общем макете конфигурации.
//
// Параметры:
//  ИмяМакета - Строка - имя общего макета в конфигурации, в котором поставляется внешняя
//    компонента,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеВнешнейКомпоненты(Знач ИмяМакета, Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "AttachAddin"));
	Результат.Description = Описание;
	
	Результат.TemplateName = ИмяМакета;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование расширения конфигурации.
//
// Параметры:
//  Имя - Строка - имя расширения конфигурации,
//  КонтрольнаяСумма - Строка - контрольная сумма расширения конфигурации.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
Функция РазрешениеНаИспользованиеВнешнегоМодуля(Знач Имя, Знач КонтрольнаяСумма, Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "ExternalModule"));
	Результат.Description = Описание;
	
	Результат.Name = Имя;
	Результат.Hash = КонтрольнаяСумма;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование приложения операционной системы.
//
// Параметры:
//  ШаблонСтрокиЗапуска - Строка - шаблон строки запуска приложения. Подробнее см. документацию
//    к платформе,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеПриложенияОперационнойСистемы(Знач ШаблонСтрокиЗапуска, Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "RunApplication"));
	Результат.Description = Описание;
	
	Результат.CommandMask = ШаблонСтрокиЗапуска;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование интернет-ресурса.
//
// Параметры:
//  Протокол: Строка - протокол, по которому выполняется взаимодействие с ресурсом. Допустимые
//    значения:
//      IMAP,
//      POP3,
//      SMTP,
//      HTTP,
//      HTTPS,
//      FTP,
//      FTPS,
//  Адрес - Строка - адрес ресурса без указания протокола,
//  Порт - Число - номер порта через который выполняется взаимодействие с ресурсом,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеИнтернетРесурса(Знач Протокол, Знач Адрес, Знач Порт = Неопределено, Знач Описание = "") Экспорт
	
	Если Порт = Неопределено Тогда
		СтандартныеПорты = СтандартныеПортыИнтернетПротоколов();
		Если СтандартныеПорты.Свойство(ВРег(Протокол)) <> Неопределено Тогда
			Порт = СтандартныеПорты[ВРег(Протокол)];
		КонецЕсли;
	КонецЕсли;
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "InternetResourceAccess"));
	Результат.Description = Описание;
	
	Результат.Protocol = Протокол;
	Результат.Host = Адрес;
	Результат.Port = Порт;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на расширенную работу с данными (включая установку
// привилегированного режима) для внешних модулей.
//
// Параметры:
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение: ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции.
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеПривилегированногоРежима(Знач Описание = "") Экспорт
	
	Пакет = РаботаВБезопасномРежимеСлужебный.Пакет();
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет, "ExternalModulePrivilegedModeAllowed"));
	Результат.Description = Описание;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции-конструкторы запросов на использование внешних ресурсов.
//

// Создает запрос на использование внешних ресурсов.
//
// Параметры:
//  НовыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    запрашиваемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны запрашиваемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, предоставление разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных,
//  РежимЗамещения - Булево - определяет режим замещения ранее выданных разрешений для данного владельца. При
//    значении параметра равным Истина, помимо предоставления запрошенных разрешений в запрос будет добавлена
//    очистка всех разрешений, ранее запрошенных для этого же владельца.
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры.
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаИспользованиеВнешнихРесурсов(Знач НовыеРазрешения, Знач Владелец = Неопределено, Знач РежимЗамещения = Истина) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросИзмененияРазрешений(
		Владелец,
		РежимЗамещения,
		НовыеРазрешения);
	
КонецФункции

// Создает запрос на отмену разрешений использования внешних ресурсов.
//
// Параметры:
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны отменяемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, отменяемые разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных,
//  ОтменяемыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    отменяемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры.
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов(Знач Владелец, Знач ОтменяемыеРазрешения) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросИзмененияРазрешений(
		Владелец,
		Ложь,
		,
		ОтменяемыеРазрешения);
	
КонецФункции

// Создает запрос на отмену всех разрешений использования внешних ресурсов, связанных в владельцем.
//
// Параметры:
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны отменяемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, отменяемые разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных.
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры.
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(Знач Владелец) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросИзмененияРазрешений(
		Владелец,
		Истина);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для поддержки работы конфигурации с профилем безопасности, в котором
// запрещено подключение внешних модулей без установки безопасного режима.
//

// Проверят установленность безопасного режима, игнорируя безопасный режим профиля безопасности,
//  использующегося в качестве профиля безопасности с уровнем привилегий конфигурации.
//
// Возвращаемое значение: Булево.
//
Функция УстановленБезопасныйРежим() Экспорт
	
	ТекущийБезопасныйРежим = БезопасныйРежим();
	
	Если ТипЗнч(ТекущийБезопасныйРежим) = Тип("Строка") Тогда
		
		Если Не ДоступенПереходВПривилегированныйРежим() Тогда
			Возврат Истина; // В небезопасном режиме переход в привилегированный режим всегда доступен.
		КонецЕсли;
		
		Попытка
			ПрофильИнформационнойБазы = ПрофильБезопасностиИнформационнойБазы();
		Исключение
			Возврат Истина;
		КонецПопытки;
		
		Возврат (ТекущийБезопасныйРежим <> ПрофильИнформационнойБазы);
		
	ИначеЕсли ТипЗнч(ТекущийБезопасныйРежим) = Тип("Булево") Тогда
		
		Возврат ТекущийБезопасныйРежим;
		
	КонецЕсли;
	
КонецФункции

// Вычисляет переданное выражение, предварительно устанавливая безопасный режим выполнения кода
//  и безопасный режим разделения данных для всех разделителей, присутствующих в составе конфигурации.
//  В результате при вычислении выражения:
//   - игнорируются попытки установки привилегированного режима,
//   - запрещаются все внешние (по отношению к платформе 1С:Предприятие) действия (COM,
//       загрузка внешних компонент, запуск внешних приложений и команд операционной системы,
//       доступ к файловой системе и Интернет-ресурсам),
//   - запрещается отключение использования разделителей сеанса,
//   - запрещается изменение значений разделителей сеанса (если разделение данным разделителем не
//       является условно выключенным),
//   - запрещается изменение объектов, которые управляют состоянием условного разделения.
//
// Параметры:
//  Выражение - Строка - выражение, которое требуется вычислить. Например, "МойМодуль.МояФункция(Параметры)".
//  Параметры - Произвольный - в качестве значения данного параметра может быть передано значение,
//    которое требуется для вычисления выражения (при этом в тексте выражения обращение к данному
//    значению должно осуществляться как к имени переменной Параметры).
//
// Возвращаемое значение: 
//   Произвольный - результат вычисления выражения.
//
Функция ВычислитьВБезопасномРежиме(Знач Выражение, Знач Параметры = Неопределено) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	МассивРазделителей = ОбщегоНазначенияПовтИсп.РазделителиКонфигурации();
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Возврат Вычислить(Выражение);
	
КонецФункции

// Выполняет произвольный алгоритм на встроенном языке 1С:Предприятия, предварительно устанавливая
//  безопасный режим выполнения кода и безопасный режим разделения данных для всех разделителей,
//  присутствующих в составе конфигурации. В результате при выполнении алгоритма:
//   - игнорируются попытки установки привилегированного режима,
//   - запрещаются все внешние (по отношению к платформе 1С:Предприятие) действия (COM,
//       загрузка внешних компонент, запуск внешних приложений и команд операционной системы,
//       доступ к файловой системе и Интернет-ресурсам),
//   - запрещается отключение использования разделителей сеанса,
//   - запрещается изменение значений разделителей сеанса (если разделение данным разделителем не
//       является условно выключенным),
//   - запрещается изменение объектов, которые управляют состоянием условного разделения.
//
// Параметры:
//  Алгоритм - Строка - содержащая произвольный алгоритм на встроенном языке 1С:Предприятия.
//  Параметры - Произвольный - в качестве значения данного параметра может быть передано значение,
//    которое требуется для выполнения алгоритма (при этом в тексте алгоритма обращение к данному
//    значению должно осуществляться как к имени переменной Параметры).
//
Процедура ВыполнитьВБезопасномРежиме(Знач Алгоритм, Знач Параметры = Неопределено) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	МассивРазделителей = ОбщегоНазначенияПовтИсп.РазделителиКонфигурации();
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Выполнить Алгоритм;
	
КонецПроцедуры

// Выполнить экспортную процедуру по имени с уровнем привилегий конфигурации.
// При включении профилей безопасности для вызова оператора Выполнить() используется
// переход в безопасный режим с профилем безопасности, используемом для информационной базы
// (если выше по стеку не был установлен другой безопасный режим).
//
// Параметры:
//  ИмяМетода  - Строка - имя экспортной процедуры в формате 
//                       <имя объекта>.<имя процедуры>, где <имя объекта> - это
//                       общий модуль или модуль менеджера объекта.
// Параметры  - Массив - параметры передаются в процедуру <ИмяЭкспортнойПроцедуры>
//                       в порядке расположения элементов массива.
// 
// Пример:
//  Параметры = Новый Массив();
//  Параметры.Добавить("1");
//  РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации("МойОбщийМодуль.МояПроцедура", Параметры);
//
Процедура ВыполнитьМетодКонфигурации(Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	ПроверитьИмяМетодаКонфигурации(ИмяМетода);
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Не УстановленБезопасныйРежим() Тогда
		
		ПрофильИнформационнойБазы = ПрофильБезопасностиИнформационнойБазы();
		
		Если ЗначениеЗаполнено(ПрофильИнформационнойБазы) Тогда
			
			УстановитьБезопасныйРежим(ПрофильИнформационнойБазы);
			Если БезопасныйРежим() = Истина Тогда
				УстановитьБезопасныйРежим(Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

// Выполнить экспортную процедуру объекта встроенного языка по имени.
// При включении профилей безопасности для вызова оператора Выполнить() используется
// переход в безопасный режим с профилем безопасности, используемом для информационной базы
// (если выше по стеку не был установлен другой безопасный режим).
//
// Параметры:
//  Объект - Произвольный - объект встроенного языка 1С:Предприятия, содержащий методы (например, ОбработкаОбъект),
//  ИмяМетода - Строка - имя экспортной процедуры модуля объекта обработки.
// Параметры - Массив - параметры передаются в процедуру <ИмяПроцедуры>
//  в порядке расположения элементов массива.
//
Процедура ВыполнитьМетодОбъекта(Знач Объект, Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	// Проверка имени метода на корректность.
	Попытка
		Тест = Новый Структура(ИмяМетода, ИмяМетода);
	Исключение
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректное значение параметра ИмяМетода (%1) в РаботаВБезопасномРежиме.ВыполнитьМетодОбъекта'"), ИмяМетода);
	КонецПопытки;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Не УстановленБезопасныйРежим() Тогда
		
		ПрофильИнформационнойБазы = ПрофильБезопасностиИнформационнойБазы();
		
		Если ЗначениеЗаполнено(ПрофильИнформационнойБазы) Тогда
			
			УстановитьБезопасныйРежим(ПрофильИнформационнойБазы);
			Если БезопасныйРежим() = Истина Тогда
				УстановитьБезопасныйРежим(Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить "Объект." + ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

// Проверяет, что переданное имя является именем экспортной процедуры конфигурации.
// Может использоваться для проверки, что переданная строка не содержит произвольного алгоритма
// на встроенном языке 1С:Предприятия перед использованием его в операторах Выполнить() и Вычислить()
// при их использовании для динамического вызова методов код конфигурации.
//
// В случае, если переданная строка не соответствует имени метода конфигурации - генерируется.
//
Процедура ПроверитьИмяМетодаКонфигурации(Знач ИмяМетода) Экспорт
	
	// Проверка предусловий на формат ИмяЭкспортнойПроцедуры.
	ЧастиИмени = СтрРазделить(ИмяМетода, ".");
	Если ЧастиИмени.Количество() <> 2 И ЧастиИмени.Количество() <> 3 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра ИмяМетода (передано значение: ""%1"") в РаботаВБезопасномРежиме.ПроверитьИмяМетодаКонфигурации'"), ИмяМетода);
	КонецЕсли;
	
	ИмяОбъекта = ЧастиИмени[0];
	Если ЧастиИмени.Количество() = 2 И Метаданные.ОбщиеМодули.Найти(ИмяОбъекта) = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра ИмяМетода (передано значение: ""%1"") в РаботаВБезопасномРежиме.ПроверитьИмяМетодаКонфигурации:
				|Не найден общий модуль ""%2"".'"),
			ИмяМетода,
			ИмяОбъекта);
	КонецЕсли;
	
	Если ЧастиИмени.Количество() = 3 Тогда
		ПолноеИмяОбъекта = ЧастиИмени[0] + "." + ЧастиИмени[1];
		Попытка
			Менеджер = МенеджерОбъектаПоИмени(ПолноеИмяОбъекта);
		Исключение
			Менеджер = Неопределено;
		КонецПопытки;
		Если Менеджер = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неправильный формат параметра ИмяМетода (передано значение: ""%1"") в РаботаВБезопасномРежиме.ПроверитьИмяМетодаКонфигурации:
				           |Не найден менеджер объекта ""%2"".'"),
				ИмяМетода,
				ПолноеИмяОбъекта);
		КонецЕсли;
	КонецЕсли;
	
	ИмяМетодаОбъекта = ЧастиИмени[ЧастиИмени.ВГраница()];
	ВременнаяСтруктура = Новый Структура;
	Попытка
		// Проверка того, что ИмяМетодаОбъекта является допустимым идентификатором.
		// Например: МояПроцедура.
		ВременнаяСтруктура.Вставить(ИмяМетодаОбъекта);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Безопасное выполнение метода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра ИмяМетода (передано значение: ""%1"") в РаботаВБезопасномРежиме.ПроверитьИмяМетодаКонфигурации:
			           |Имя метода ""%2"" не соответствует требованиям образования имен процедур и функций.'"),
			ИмяМетода,
			ИмяМетодаОбъекта);
	КонецПопытки;
	
КонецПроцедуры

// Проверяет возможность выполнения обработчиков установки параметров сеанса.
//
// В случае, если при текущих настройках профилей безопасности (в кластере серверов и в информационной
// базе) выполнение обработчиков установки параметров сеанса невозможно - генерируется исключение,
// содержащее описание причины невозможности выполнения обработчиков установки параметров сеанса
// и перечень действий, которые можно предпринять для устранения этой причины.
//
Процедура ПроверитьВозможностьВыполненияОбработчиковУстановкиПараметровСеанса() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияИнформационнойБазы()) Тогда
		Возврат;
	КонецЕсли;
	
	ПрофильИнформационнойБазы = ПрофильБезопасностиИнформационнойБазы();
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И ЗначениеЗаполнено(ПрофильИнформационнойБазы) Тогда
		
		// Информационная база настроена на использование с профилем безопасности, в котором запрещен
		// полный доступ к внешним модулям.
		
		УстановитьБезопасныйРежим(ПрофильИнформационнойБазы);
		Если БезопасныйРежим() <> ПрофильИнформационнойБазы Тогда
			
			// Профиль ИБ не доступен для выполнения обработчиков.
			
			УстановитьБезопасныйРежим(Ложь);
			
			Если ВозможноВыполнениеОбработчиковУстановкиПараметровСеансаБезУстановкиБезопасногоРежима() Тогда
				
				Возврат;
				
			Иначе
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: профиль безопасности %1 отсутствует в кластере серверов 1С:Предприятия, или для него запрещено использование в качестве профиля безопасности безопасного режима.
						|
						|Для восстановления работоспособности программы требуется отключить использование профиля безопасности через консоль кластера и заново настроить профили безопасности с помощью интерфейса конфигурации (соответствующие команды находятся в разделе настроек программы).'"),
					ПрофильИнформационнойБазы);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ДоступенПривилегированныйРежим = ДоступенПереходВПривилегированныйРежим();
		
		УстановитьБезопасныйРежим(Ложь);
		
		Если Не ДоступенПривилегированныйРежим Тогда
			
			// Профиль ИБ доступен для выполнения обработчиков, но в нем невозможна установка привилегированного режима.
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: профиль безопасности %1 не содержит разрешения на установку привилегированного режима. Возможно, он был отредактирован через консоль кластера.
					|
					|Для восстановления работоспособности программы требуется отключить использование профиля безопасности через консоль кластера и заново настроить профили безопасности с помощью интерфейса конфигурации (соответствующие команды находятся в разделе настроек программы).'"),
				ПрофильИнформационнойБазы);
			
		КонецЕсли;
		
	Иначе
		
		// Информационная база не настроена на использование с профилем безопасности, в котором запрещен
		// полный доступ к внешним модулям.
		
		Попытка
			
			ДоступенПривилегированныйРежим = Вычислить("ДоступенПереходВПривилегированныйРежим()");
			
		Исключение
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: %1.
					|
					|Возможно, для информационной базы через консоль кластера был установлен профиль безопасности, не допускающий выполнения внешних модулей без установки безопасного режима. В этом случае для восстановления работоспособности программы требуется отключить использование профиля безопасности через консоль кластера и заново настроить профили безопасности с помощью интерфейса конфигурации (соответствующие команды находятся в разделе настроек программы).При этом программа будет автоматически корректно настроена на использование совместно с включенными профилями безопасности.'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее
//

// Создает запросы на обновление разрешений конфигурации.
//
// Параметры:
//  ВключаяЗапросСозданияПрофиляИБ - Булево - включать в результат запрос на создание профиля безопасности
//    для текущей информационной базы.
//
// Возвращаемое значение: Массив(УникальныйИдентификатор) - идентификаторы запросов для обновления разрешений
// конфигурации до требуемых в настоящий момент.
//
Функция ЗапросыОбновленияРазрешенийКонфигурации(Знач ВключаяЗапросСозданияПрофиляИБ = Истина) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросыОбновленияРазрешенийКонфигурации(ВключаяЗапросСозданияПрофиляИБ);
	
КонецФункции

// Возвращает контрольные суммы файлов комплекта внешней компоненты, поставляемого в макете конфигурации.
//
// Параметры:
//  ИмяМакета - Строка - имя макета конфигурации, в составе которого поставляется комплект внешней компоненты.
//
// Возвращаемое значение - ФиксированноеСоответствие:
//                         * Ключ - Строка - имя файла,
//                         * Значение - Строка - контрольная сумма.
//
Функция КонтрольныеСуммыФайловКомплектаВнешнейКомпоненты(Знач ИмяМакета) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.КонтрольныеСуммыФайловКомплектаВнешнейКомпоненты(ИмяМакета);
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Проверяет возможность выполнения обработчиков установки параметров сеанса без установки безопасного режима.
//
// Возвращаемое значение: Булево.
//
Функция ВозможноВыполнениеОбработчиковУстановкиПараметровСеансаБезУстановкиБезопасногоРежима() Экспорт
	
	Попытка
		
		Результат = Вычислить("ДоступенПереходВПривилегированныйРежим()");
		Возврат Результат;
		
	Исключение
		
		ШаблонЗаписиЖР = НСтр("ru = 'При установке параметров сеанса произошла ошибка:
			|
			|--------------------------------------------------------------------------------------------
			|%1
			|--------------------------------------------------------------------------------------------
			|
			|Запуск программы будет невозможен.'");
		
		ТекстЗаписиЖР = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаписиЖР, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Установка параметров сеанса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстЗаписиЖР);
		
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает менеджер объекта по имени.
// Ограничение: не обрабатываются точки маршрутов бизнес-процессов.
//
// Параметры:
//  Имя - Строка - имя например, "Справочник", "Справочники", "Справочник.Организации".
//
// Возвращаемое значение:
//  СправочникиМенеджер, СправочникМенеджер, ДокументыМенеджер, ДокументМенеджер, ...
// 
Функция МенеджерОбъектаПоИмени(Имя)
	Перем КлассОМ, ИмяОМ, Менеджер;
	
	ЧастиИмени = СтрРазделить(Имя, ".");
	
	Если ЧастиИмени.Количество() > 0 Тогда
		КлассОМ = ВРег(ЧастиИмени[0]);
	КонецЕсли;
	
	Если ЧастиИмени.Количество() > 1 Тогда
		ИмяОМ = ЧастиИмени[1];
	КонецЕсли;
	
	Если      КлассОМ = "ПЛАНОБМЕНА"
	 Или      КлассОМ = "ПЛАНЫОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли КлассОМ = "СПРАВОЧНИК"
	      Или КлассОМ = "СПРАВОЧНИКИ" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли КлассОМ = "ДОКУМЕНТ"
	      Или КлассОМ = "ДОКУМЕНТЫ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли КлассОМ = "ЖУРНАЛДОКУМЕНТОВ"
	      Или КлассОМ = "ЖУРНАЛЫДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли КлассОМ = "ПЕРЕЧИСЛЕНИЕ"
	      Или КлассОМ = "ПЕРЕЧИСЛЕНИЯ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли КлассОМ = "ОТЧЕТ"
	      Или КлассОМ = "ОТЧЕТЫ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли КлассОМ = "ОБРАБОТКА"
	      Или КлассОМ = "ОБРАБОТКИ" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли КлассОМ = "ПЛАНВИДОВХАРАКТЕРИСТИК"
	      Или КлассОМ = "ПЛАНЫВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли КлассОМ = "ПЛАНСЧЕТОВ"
	      Или КлассОМ = "ПЛАНЫСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли КлассОМ = "ПЛАНВИДОВРАСЧЕТА"
	      Или КлассОМ = "ПЛАНЫВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли КлассОМ = "РЕГИСТРСВЕДЕНИЙ"
	      Или КлассОМ = "РЕГИСТРЫСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли КлассОМ = "РЕГИСТРНАКОПЛЕНИЯ"
	      Или КлассОМ = "РЕГИСТРЫНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли КлассОМ = "РЕГИСТРБУХГАЛТЕРИИ"
	      Или КлассОМ = "РЕГИСТРЫБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли КлассОМ = "РЕГИСТРРАСЧЕТА"
	      Или КлассОМ = "РЕГИСТРЫРАСЧЕТА" Тогда
		
		Если ЧастиИмени.Количество() < 3 Тогда
			// Регистр расчета
			Менеджер = РегистрыРасчета;
		Иначе
			КлассПодчиненногоОМ = ВРег(ЧастиИмени[2]);
			Если ЧастиИмени.Количество() > 3 Тогда
				ИмяПодчиненногоОМ = ЧастиИмени[3];
			КонецЕсли;
			Если КлассПодчиненногоОМ = "ПЕРЕРАСЧЕТ"
			 Или КлассПодчиненногоОМ = "ПЕРЕРАСЧЕТЫ" Тогда
				// Перерасчет
				Попытка
					Менеджер = РегистрыРасчета[ИмяОМ].Перерасчеты;
					ИмяОМ = ИмяПодчиненногоОМ;
				Исключение
					Менеджер = Неопределено;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли КлассОМ = "БИЗНЕСПРОЦЕСС"
	      Или КлассОМ = "БИЗНЕСПРОЦЕССЫ" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли КлассОМ = "ЗАДАЧА"
	      Или КлассОМ = "ЗАДАЧИ" Тогда
		Менеджер = Задачи;
		
	ИначеЕсли КлассОМ = "КОНСТАНТА"
	      Или КлассОМ = "КОНСТАНТЫ" Тогда
		Менеджер = Константы;
		
	ИначеЕсли КлассОМ = "ПОСЛЕДОВАТЕЛЬНОСТЬ"
	      Или КлассОМ = "ПОСЛЕДОВАТЕЛЬНОСТИ" Тогда
		Менеджер = Последовательности;
	КонецЕсли;
	
	Если Менеджер <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяОМ) Тогда
			Попытка
				Возврат Менеджер[ИмяОМ];
			Исключение
				Менеджер = Неопределено;
			КонецПопытки;
		Иначе
			Возврат Менеджер;
		КонецЕсли;
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось получить менеджер для объекта ""%1""'"), Имя);
	
КонецФункции

// Проверяет возможность перехода в привилегированный режим из текущего безопасного режима.
//
// Возвращаемое значение: Булево.
//
Функция ДоступенПереходВПривилегированныйРежим()
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПривилегированныйРежим();
	
КонецФункции

// Возвращает имя профиля безопасности, предоставляющего привилегии кода конфигурации.
//
// Возвращаемое значение: Строка - имя профиля безопасности.
//
Функция ПрофильБезопасностиИнформационнойБазы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ПрофильБезопасностиИнформационнойБазы.Получить();
	
КонецФункции

// Возвращает "предопределенный" псевдоним (alias) для каталога программы.
//
// Возвращаемое значение: Строка.
//
Функция ПсевдонимКаталогаПрограммы()
	
	Возврат "/bin";
	
КонецФункции

// Возвращает "предопределенный" псевдоним (alias) для каталога временных файлов.
//
Функция ПсевдонимКаталогаВременныхФайлов()
	
	Возврат "/temp";
	
КонецФункции

// Возвращает стандартные сетевые порты для Интернет-протоколов, инструменты для использования которых
//  есть во встроенном языке 1С:Предприятия. Используется для определения сетевого порта в тех
//  случаях, когда из прикладного кода запрашивается разрешение без указания сетевого порта.
//
// Возвращаемое значение: ФиксированнаяСтруктура:
//                          * Ключ - Строка, имя Интернет-протокола,
//                          * Значение - Число, номер сетевого порта.
//
Функция СтандартныеПортыИнтернетПротоколов()
	
	Результат = Новый Структура();
	
	Результат.Вставить("IMAP",  143);
	Результат.Вставить("POP3",  110);
	Результат.Вставить("SMTP",  25);
	Результат.Вставить("HTTP",  80);
	Результат.Вставить("HTTPS", 443);
	Результат.Вставить("FTP",   21);
	Результат.Вставить("FTPS",  21);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

