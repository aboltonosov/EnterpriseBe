﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);

	НастроитьОтображениеФормы();
	ЗаполнитьДанныеФормы();
	
	// Состояние подключения Интернет-поддержки
	Если Элементы.ГруппаПодключениеИПП.Видимость Тогда
		УстановитьПривилегированныйРежим(Истина);
		ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если ДанныеАутентификации <> Неопределено Тогда
			ДанныеАутентификации.Пароль = "";
		КонецЕсли;
		ОтобразитьСостояниеПодключенияИПП();
	КонецЕсли;
	// Конец Состояние подключения Интернет-поддержки
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтернетПоддержкаПодключена" Тогда
		// Обработка подключения Интернет-поддержки
		
		ВведенныеДанныеАутентификации = Параметр;
		Если ВведенныеДанныеАутентификации <> Неопределено Тогда
			ДанныеАутентификации = ВведенныеДанныеАутентификации;
			ОтобразитьСостояниеПодключенияИПП();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЛогинИППОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
		ИнтернетПоддержкаПользователейКлиентСервер.URLСтраницыПорталаПоддержки("/software?needAccessToken=true"),
		НСтр("ru = 'Личный кабинет пользователя'"));
	
КонецПроцедуры

// ИнтернетПоддержкаПользователей.СПАРКРиски
&НаКлиенте
Процедура ИспользоватьСервисСПАРКРискиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.СПАРКРиски

// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
&НаКлиенте
Процедура АвтоматическаяПроверкаОбновленийПриИзменении(Элемент)
	
	Элементы.ДекорацияРасписание.Доступность = (АвтоматическаяПроверкаОбновлений = 2);
	
	МодульПолучениеОбновленийПрограммыКлиент       = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
	МодульПолучениеОбновленийПрограммыВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыВызовСервера");
	
	НастройкиОбновления = МодульПолучениеОбновленийПрограммыКлиент.ГлобальныеНастройкиОбновления();
	НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = АвтоматическаяПроверкаОбновлений;
	МодульПолучениеОбновленийПрограммыВызовСервера.ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
	Если ИнтернетПоддержкаПользователейКлиент.ЗначениеПараметраПриложения("ПолучениеОбновленийПрограммы\ИДЗадания") = Неопределено Тогда
		// Если выполняется задание проверки, тогда после завершения очередной проверки
		// настройки будут применены автоматически.
		Если АвтоматическаяПроверкаОбновлений <> 2 Тогда
			МодульПолучениеОбновленийПрограммыКлиент.ОтключитьПроверкуПоРасписанию();
		Иначе
			МодульПолучениеОбновленийПрограммыКлиент.ПодключитьПроверкуПоРасписанию();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРасписаниеНажатие(Элемент)
	
	МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
	
	НастройкиОбновления = МодульПолучениеОбновленийПрограммыКлиент.ГлобальныеНастройкиОбновления();
	РасписаниеПроверки = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиОбновления.Расписание);
	ДиалогРасписание = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеПроверки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриИзмененииРасписания", ЭтотОбъект);
	ДиалогРасписание.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогДистрибутиваПлатформыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	#Если Не ВебКлиент Тогда
	ЗапуститьПриложение(КаталогДистрибутиваПлатформы);
	#КонецЕсли
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы


// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ДетализироватьОбновлениеИБВЖурналеРегистрацииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

// ИнтернетПоддержкаПользователей.Новости
&НаКлиенте
Процедура РазрешенаРаботаСНовостямиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина); // Обновить интерфейс
	// ГруппаНастройкиНовостей исчезнет / появится при изменении функциональной опции
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВойтиИлиВыйтиИПП(Команда)
	
	Если ДанныеАутентификации = Неопределено Тогда
		
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			,
			ЭтотОбъект);
		
	Иначе
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПриОтветеНаВопросОВыходеИзИнтернетПоддержки", ЭтотОбъект),
			НСтр("ru = 'Логин и пароль для подключения к сервисам Интернет-поддержки пользователей будут удалены из программы.
				|Отключить Интернет-поддержку?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			КодВозвратаДиалога.Нет,
			НСтр("ru = 'Выход из Интернет-поддержки пользователей'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеВТехПоддержку(Команда)
	
	ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
		НСтр("ru = 'Интернет-поддержка пользователей'"),
		НСтр("ru = '<Заполните текст сообщения>'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНастройкиСоединенияССервером(Команда)
	
	ОткрытьФорму(
		"ОбщаяФорма.НастройкиСоединенияССерверомИнтернетПоддержки",
		,
		ЭтотОбъект,
		"",
		ВариантОткрытияОкна.ОтдельноеОкно,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки
&НаКлиенте
Процедура КомандаМониторИнтернетПоддержки(Команда)
	
	МодульМониторИнтернетПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("МониторИнтернетПоддержкиКлиент");
	МодульМониторИнтернетПоддержкиКлиент.ОткрытьМониторИнтернетПоддержки();
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки

// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
&НаКлиенте
Процедура ОбновлениеПрограммы(Команда)
	
	МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
	МодульПолучениеОбновленийПрограммыКлиент.ОбновитьПрограмму();
	
КонецПроцедуры
// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы


// ИнтернетПоддержкаПользователей.Новости
&НаКлиенте
Процедура КомандаУправлениеНовостями(Команда)
	
	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма",
		,
		ЭтотОбъект,
		"",
		ВариантОткрытияОкна.ОтдельноеОкно,
		,
		,
		РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

// СтандартныеПодсистемы.ОбновлениеВерсииИБ
&НаКлиенте
Процедура ОтложеннаяОбработкаДанных(Команда)
	
	ПараметрыФормы = Новый Структура("ОткрытиеИзПанелиАдминистрирования", Истина);
	ОткрытьФорму(
		"Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ",
		ПараметрыФормы);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьОтображениеФормы()
	
	Элементы.ГруппаПодключениеИПП.Видимость = ИнтернетПоддержкаПользователейВызовСервера.ДоступноПодключениеИнтернетПоддержки();
	Элементы.ГруппаОбращениеВТехПоддержку.Видимость = Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	Элементы.ГруппаНастройкиСоединенияССервером.Видимость = ИнтернетПоддержкаПользователейВызовСервера.ДоступнаНастройкаПараметровПодключенияКИнтернетПоддержке();
	
	// ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки") Тогда
		МодульМониторИнтернетПоддержки = ОбщегоНазначения.ОбщийМодуль("МониторИнтернетПоддержки");
		Элементы.ГруппаМониторИнтернетПоддержки.Видимость = МодульМониторИнтернетПоддержки.ДоступноИспользованиеМонитораИнтернетПоддержки();
	Иначе
		Элементы.ГруппаМониторИнтернетПоддержки.Видимость = Ложь;
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки
	
	// 4D:ERP для Беларуси, Дмитрий, 07.09.2017 14:28:44 
	// Локализация экранных форм
	// {
	// ИнтернетПоддержкаПользователей.СПАРКРиски
	Элементы.ГруппаСПАРКРиски.Видимость = Ложь;
	// Конец ИнтернетПоддержкаПользователей.СПАРКРиски
	// }
	// 4D
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	Элементы.ГруппаДетализироватьОбновлениеИБВЖурналеРегистрации.Видимость = РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
	// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		ДоступноИспользованиеОбновленияПрограммы =
			МодульПолучениеОбновленийПрограммы.ДоступноИспользованиеОбновленияПрограммы();
		Элементы.ГруппаОбновлениеПрограммы.Видимость    = ДоступноИспользованиеОбновленияПрограммы;
		Элементы.КаталогДистрибутиваПлатформы.Видимость = ДоступноИспользованиеОбновленияПрограммы;
		
	Иначе
		
		Элементы.ГруппаОбновлениеПрограммы.Видимость    = Ложь;
		Элементы.КаталогДистрибутиваПлатформы.Видимость = Ложь;
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
	
	// ИнтернетПоддержкаПользователей.Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости")
			И РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Элементы.ГруппаУправлениеНовостями.Видимость = Истина;
	Иначе
		Элементы.ГруппаУправлениеНовостями.Видимость = Ложь;
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	Если Элементы.Найти("ОткрытьОписаниеИзмененийСистемы") = Неопределено Тогда
		Элементы.ГруппаОткрытьОписаниеИзмененийСистемы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормы()
	
	// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
	Если Элементы.ГруппаОбновлениеПрограммы.Видимость Тогда
		
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		НастройкиОбновления = МодульПолучениеОбновленийПрограммы.НастройкиАвтоматическогоОбновления();
		
		АвтоматическаяПроверкаОбновлений = НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы;
		Элементы.ДекорацияРасписание.Доступность = (АвтоматическаяПроверкаОбновлений = 2);
		Элементы.ДекорацияРасписание.Заголовок = ПредставлениеРасписания(НастройкиОбновления.Расписание);
		
		Если Не МодульПолучениеОбновленийПрограммы.ЭтоФайловаяИБ() Тогда
			Элементы.КаталогДистрибутиваПлатформы.Видимость = Ложь;
		Иначе
			КаталогДистрибутиваПлатформы = МодульПолучениеОбновленийПрограммы.КаталогСохраненияПоследнегоПолученногоДистрибутива();
			Элементы.КаталогДистрибутиваПлатформы.Видимость = Не ПустаяСтрока(КаталогДистрибутиваПлатформы);
		КонецЕсли;
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

КонецПроцедуры

&НаСервере
Процедура ОтобразитьСостояниеПодключенияИПП()
	
	Если ДанныеАутентификации = Неопределено Тогда
		Элементы.ДекорацияЛогинИПП.Заголовок = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
			НСтр("ru = 'Подключение к Интернет-поддержке не выполнено.'"));
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Подключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Иначе
		ШаблонЗаголовка = ИнтернетПоддержкаПользователейКлиентСервер.ПодставитьДомен(
			НСтр("ru = '<body>Подключена Интернет-поддержка для пользователя <a href=""action:openUsersSite"">%1</body>'"));
		Элементы.ДекорацияЛогинИПП.Заголовок = ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗаголовка,
				ДанныеАутентификации.Логин));
		Элементы.ВойтиИлиВыйтиИПП.Заголовок = НСтр("ru = 'Отключить'");
		Элементы.ВойтиИлиВыйтиИПП.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОВыходеИзИнтернетПоддержки(КодВозврата, ДопПараметры) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.Да Тогда
		ВыйтиИзИППСервер();
		ДанныеАутентификации = Неопределено;
		ОтобразитьСостояниеПодключенияИПП();
		Оповестить("ИнтернетПоддержкаОтключена");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыйтиИзИППСервер()
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для записи данных аутентификации Интернет-поддержки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СохранитьДанныеАутентификации(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую.
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")

	Если Не РежимРаботы.ЭтоАдминистраторСистемы Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()

	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;

КонецПроцедуры

// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы
&НаКлиенте
Процедура ПриИзмененииРасписания(Расписание, ДопПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПериодПовтораВТечениеДня = Расписание.ПериодПовтораВТечениеДня;
	Если АвтоматическаяПроверкаОбновлений = 2
		И ПериодПовтораВТечениеДня > 0
		И ПериодПовтораВТечениеДня < 300 Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Интервал проверки не может быть задан чаще, чем один раз 5 минут.'"));
		Возврат;
	КонецЕсли;
	
	Элементы.ДекорацияРасписание.Заголовок = ПредставлениеРасписания(Расписание);
	
	МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
	МодульПолучениеОбновленийПрограммыВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыВызовСервера");
	
	НастройкиОбновления = МодульПолучениеОбновленийПрограммыКлиент.ГлобальныеНастройкиОбновления();
	НастройкиОбновления.Расписание = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
	МодульПолучениеОбновленийПрограммыВызовСервера.ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеРасписания(Расписание)

	Если Расписание = Неопределено Тогда
		Возврат НСтр("ru = 'Настроить расписание'");
	Иначе
		Если ТипЗнч(Расписание) = Тип("Структура") Тогда
			Возврат Строка(ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание));
		Иначе
			Возврат Строка(Расписание);
		КонецЕсли;
	КонецЕсли;

КонецФункции
// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

#КонецОбласти
