﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработкаСтрок

// Получает текстовое описание структуры расписания.
//
// Параметры:
//  СтруктураРасписания - Структура - структура с ключами, как описано в ХранилищаНастроек.НастройкиОблачногоАрхива
//                          для настройки НастройкиАгентаКопирования.РасписаниеАвтоматическогоРезервногоКопирования;
//  Вариант             - Строка - "Кратко" или "Подробно" (по-умолчанию).
//
// Возвращаемое значение:
//   Строка - Текстовое описание расписания.
//
Функция ПолучитьТекстовоеОписаниеРасписания(СтруктураРасписания, Вариант = "Подробно") Экспорт

	// Никакие проверки на правильность не вызываются, все поля должны присутствовать.

	ТипСтруктура = Тип("Структура");

	Результат = "";

	Если ТипЗнч(СтруктураРасписания) = ТипСтруктура Тогда

		// Обязательные поля:
		//  ** РасписаниеВключено - Булево;
		//  ** Вариант - Строка - "Ежедневно_ОдинРазВДень", "Ежедневно_НесколькоРазВДень", "Еженедельно",
		//               "Ежемесячно_ПоДням", "Ежемесячно_ПоДнямНедели".
		//               Возможно добавление варианта "Однократно" перед остальными вариантами.
		//  ** Ежедневно_ОдинРазВДень:
		//    *** Время (Время);
		//  ** Ежедневно_НесколькоРазВДень:
		//    *** ВремяНачала (Время);
		//    *** ВремяОкончания (Время);
		//    *** КоличествоЧасовПовтора (Число 1..23);
		//  ** Еженедельно:
		//    *** Время (Время);
		//    *** ДниНедели (Массив (числа 1..7));
		//  ** Ежемесячно_ПоДням:
		//    *** Время (Время);
		//    *** ДниМесяца (Массив (числа 1..32));
		//  ** Ежемесячно_ПоДнямНедели:
		//    *** Время (Время);
		//    *** НомерНедели (Число 1..5) (first, second, third, fourth, last);
		//    *** ДниНедели (Массив (числа 1..7)).

		// Расписание вообще включено?
		Если СтруктураРасписания.РасписаниеВключено = Истина Тогда

			// Ежедневно_ОдинРазВДень
			Если СтруктураРасписания.Вариант = "Ежедневно_ОдинРазВДень" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежедневно_ОдинРазВДень;
				Результат =
					Результат
					+ СтрШаблон(НСтр("ru='#Ежедневно в %1#'"),
						Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат = НРег(Результат);
				КонецЕсли;
			КонецЕсли;

			// Ежедневно_НесколькоРазВДень
			Если СтруктураРасписания.Вариант = "Ежедневно_НесколькоРазВДень" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежедневно_НесколькоРазВДень;
				Если ЭлементСтруктуры.КоличествоЧасовПовтора = 1 Тогда
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#Ежедневно с %1 до %2 каждый час#'"),
							Формат(ЭлементСтруктуры.ВремяНачала, "ДФ=HH:mm"),
							Формат(ЭлементСтруктуры.ВремяОкончания, "ДФ=HH:mm"));
				Иначе
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#Ежедневно с %1 до %2 каждые %3#'"),
							Формат(ЭлементСтруктуры.ВремяНачала, "ДФ=HH:mm"),
							Формат(ЭлементСтруктуры.ВремяОкончания, "ДФ=HH:mm"),
							НРег(ЧислоПрописью(ЭлементСтруктуры.КоличествоЧасовПовтора, "Л=ru_RU;НП=Истина", "час,часа,часов,м,,,,,0")));
				КонецЕсли;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат = НРег(Результат);
				КонецЕсли;
			КонецЕсли;

			// Еженедельно
			Если СтруктураРасписания.Вариант = "Еженедельно" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Еженедельно;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#еженедельно в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					СписокДнейНедели = "";
					Для Каждого ТекущийДеньНедели Из ЭлементСтруктуры.ДниНедели Цикл
						СписокДнейНедели = СписокДнейНедели + "#" + ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеДняНедели(ТекущийДеньНедели) + "#";
					КонецЦикла;
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ", ");
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#В %1 по дням недели: %2#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейНедели);
				КонецЕсли;
			КонецЕсли;

			// Ежемесячно_ПоДням
			Если СтруктураРасписания.Вариант = "Ежемесячно_ПоДням" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежемесячно_ПоДням;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#в определенные числа месяца в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					СписокДнейМесяца = "";
					Для Каждого ТекущийДеньМесяца Из ЭлементСтруктуры.ДниМесяца Цикл
						Если (ТекущийДеньМесяца = 32) ИЛИ (ТекущийДеньМесяца = 99) Тогда
							СписокДнейМесяца = СписокДнейМесяца + "#" + НСтр("ru='последний день месяца'") + "#";
						Иначе
							СписокДнейМесяца = СписокДнейМесяца + "#" + ТекущийДеньМесяца + "#";
						КонецЕсли;
					КонецЦикла;
					СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "##", ", ");
					СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "#", "");
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#В %1 по числам месяца: %2#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейМесяца);
				КонецЕсли;
			КонецЕсли;

			// Ежемесячно_ПоДнямНедели
			Если СтруктураРасписания.Вариант = "Ежемесячно_ПоДнямНедели" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежемесячно_ПоДнямНедели;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#в определенные дни недель в пределах месяца в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					Если ЭлементСтруктуры.НомерНедели = 1 Тогда
						НомерНеделиСтрокой = НСтр("ru='первой'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 2 Тогда
						НомерНеделиСтрокой = НСтр("ru='второй'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 3 Тогда
						НомерНеделиСтрокой = НСтр("ru='третьей'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 4 Тогда
						НомерНеделиСтрокой = НСтр("ru='четвертой'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 5 Тогда
						НомерНеделиСтрокой = НСтр("ru='последней'");
					КонецЕсли;

					СписокДнейНедели = "";
					Для Каждого ТекущийДеньНедели Из ЭлементСтруктуры.ДниНедели Цикл
						СписокДнейНедели = СписокДнейНедели + "#" + ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеДняНедели(ТекущийДеньНедели) + "#";
					КонецЦикла;
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ", ");
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");

					Результат =
						Результат
						+ СтрШаблон(НСтр("ru='#В %1 по дням недели: %2 каждой %3 недели#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейНедели,
							НомерНеделиСтрокой);
				КонецЕсли;
			КонецЕсли;

		Иначе

			Если ВРег(Вариант) = ВРег("Кратко") Тогда
				Результат =
					Результат
					+ НСтр("ru='отключено'");
			Иначе // Подробно.
				Результат =
					Результат
					+ НСтр("ru='Выполнение по-расписанию отключено.'");
			КонецЕсли;

		КонецЕсли;

		Результат = СтрЗаменить(Результат, "##", "; ");
		Результат = СтрЗаменить(Результат, "#", "");

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Преобразует размер в байтах в мегабайты или оставляет в байтах, если размер маленький.
//
// Параметры:
//  Размер - Число - число, которые необходимо преобразовать в текст.
//
// Возвращаемое значение:
//   Строка - текстовое представление в байтах или в мегабайтах.
//
Функция ПолучитьПредставлениеРазмера(Размер) Экспорт

	Результат = "";
	Если Размер < 1*1024*1024 Тогда // До 1 Мб - в байтах
		Результат = СтрШаблон(
			НСтр("ru='%1 байт'"),
			Формат(Размер, "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"));
	Иначе // В Мегабайтах
		Результат = СтрШаблон(
			НСтр("ru='%1 Мбайт'"),
			Формат(Окр(Размер / 1024 / 1024, 0, РежимОкругления.Окр15как20), "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"));
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает список символов, запрещенных для использования в параметрах командной строки, т.к. могут привести к неожиданным последствиям.
//
// Возвращаемое значение:
//  Строка - список запрещенных символов.
//
Функция ЗапрещенныеСимволыДляКоманднойСтроки() Экспорт

	Результат = "<>?|;$`";

	Возврат Результат;

КонецФункции

// Проверяет строку на наличие запрещенных для использования в командной строке символов.
//
// Параметры:
//  СтрокаДляПроверки - Строка - строка, которую необходимо проверить на наличие запрещенных символов;
//  ТекстОшибки       - Строка - строка со списком найденных запрещенных символов.
//
// Возвращаемое значение:
//  Булево - Истина, если есть запрещенные символы.
//
Функция ЕстьЗапрещенныеСимволыДляКоманднойСтроки(СтрокаДляПроверки, ТекстОшибки = Неопределено) Экспорт

	Результат = Ложь;
	НайденныеЗапрещенныеСимволы = Новый Соответствие;
	ТекстОшибки = "";

	ЗапрещенныеСимволы = ЗапрещенныеСимволыДляКоманднойСтроки();

	ВсегоСимволов = СтрДлина(ЗапрещенныеСимволы);
	Для С=1 По ВсегоСимволов Цикл
		ТекущийСимвол = Сред(ЗапрещенныеСимволы, С, 1);
		ЧислоВхождений = СтрЧислоВхождений(СтрокаДляПроверки, ТекущийСимвол);
		Если ЧислоВхождений > 0 Тогда
			Результат = Истина;
			НайденныеЗапрещенныеСимволы.Вставить(ТекущийСимвол, ЧислоВхождений);
		КонецЕсли;
	КонецЦикла;

	Если Результат = Истина Тогда
		СписокНайденныхЗапрещенныхСимволов = "";
		Для Каждого КлючЗначение Из НайденныеЗапрещенныеСимволы Цикл
			СписокНайденныхЗапрещенныхСимволов = СписокНайденныхЗапрещенныхСимволов
				+ СтрШаблон(
					"#%1 (%2)#", 
					КлючЗначение.Ключ,
					КлючЗначение.Значение);
		КонецЦикла;
		СписокНайденныхЗапрещенныхСимволов = СтрЗаменить(СписокНайденныхЗапрещенныхСимволов, "##", ", ");
		СписокНайденныхЗапрещенныхСимволов = СтрЗаменить(СписокНайденныхЗапрещенныхСимволов, "#", "");
		ТекстОшибки = СтрШаблон(
			НСтр("ru='Найдены запрещенные символы: %1'"),
			СписокНайденныхЗапрещенныхСимволов);
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область УстаревшийФункционал

// Устаревший функционал 2.1.8.
// Заменено на ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения.
// Функция возвращает строковое представление для произвольного значения.
// Это базовый функционал.
//
// Параметры:
//  лкЗначение   - Произвольный - значение произвольного типа, которое надо вывести в виде строки;
//  Разделитель1 - Строка - разделитель значений 1 (например, разделяет элементы массива или ключ и значение структуры или соответствия);
//  Разделитель2 - Строка - разделитель значений 2 (например, разделяет элементы структуры или соответствия);
//  Уровень      - Число  - Значение уровня, влияет на отступ.
//
// Возвращаемое значение:
//   Строка - строковое представление.
//
Функция ПолучитьСтроковоеПредставление(лкЗначение, Разделитель1 = "", Разделитель2 = "", Знач Уровень = 0) Экспорт

	Возврат ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(лкЗначение, Разделитель1, Разделитель2, Уровень);

КонецФункции

// Устаревший функционал 2.1.8.
// Заменено на СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов.
// Функция повторяет символы заданное количество раз.
// Это базовый функционал.
//
// Параметры:
//  СимволыДляПовтора  - Строка - Символы, которые необходимо повторить;
//  КоличествоПовторов - Число - количество повторов.
//
// Возвращаемое значение:
//   Строка - результирующая строка.
//
Функция ПовторитьСимволы(СимволыДляПовтора = "  ", КоличествоПовторов = 0) Экспорт

	Возврат СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(СимволыДляПовтора, КоличествоПовторов);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВебСервисы

#Область ВебСервисыАвторизации1С

Функция ПолучитьАдресWSDLАвторизации1С() Экспорт

	Возврат "https://login.1c.ru/api/public/ticket?wsdl";

КонецФункции

#КонецОбласти

#Область ВебСервисыОблачногоАрхиваПубличные

Функция ПолучитьАдресWSDLБэкап1СПубличный() Экспорт

	Возврат "https://backup.1c.ru/api/public/v1/index.php?wsdl";

КонецФункции

#КонецОбласти

#Область ВебСервисыОблачногоАрхиваПриватные

Функция ПолучитьАдресWSDLБэкап1СПриватный() Экспорт

	Возврат "https://backup.1c.ru/api/private/v1/index.php?wsdl";

КонецФункции

#КонецОбласти

#Область ВебСервисыАгентаКопирования

Функция ПолучитьАдресRESTAPIВерсийАгентаКопирования() Экспорт

	Возврат "https://update-api.1c.ru/update-platform/backupAgent/v1/update/info";

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СборДанных

// Возвращает структуру шага для сбора данных процедурой "ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву".
//
// Возвращаемое значение:
//   Структура - Структура с определенными ключами, см. код.
//
Функция ПолучитьСтруктуруШагаСбораДанных() Экспорт

	Результат = Новый Структура("КодШага, ОписаниеШага, СрокУстареванияСекунд");

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Устаревший функционал 2.1.8.
// Заменено на ИнтернетПоддержкаПользователейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации.
// Регистрирует начало шага выполнения.
// Это базовый функционал.
//
// Параметры:
//  ШагВыполнения - Структура - см. возврат ИнтернетПоддержкаПользователейКлиентСервер.СтруктураШагаВыполнения;
//  ИдентификаторШага - Строка - Произвольный идентификатор;
//  Шаг - Строка - Произвольное описание шага.
//
Процедура ЗарегистрироватьНачалоШагаВыполнения(ШагВыполнения, ИдентификаторШага, Шаг) Экспорт

	ШагВыполнения.Вставить("ИдентификаторШага", ИдентификаторШага);
	ШагВыполнения.Вставить("Шаг", Шаг);
	ШагВыполнения.Вставить("ВремяНачала", ТекущаяУниверсальнаяДатаВМиллисекундах());

КонецПроцедуры

// Устаревший функционал 2.1.8.
// Регистрирует завершение шага выполнения.
// Это базовый функционал.
//
// Параметры:
//  ШагВыполнения - Структура - см. возврат ИнтернетПоддержкаПользователейКлиентСервер.СтруктураШагаВыполнения;
//  КодРезультата - Число - Произвольный код описания возврата, 0 = нет ошибок;
//  ОписаниеРезультата - Строка - произвольное описание результата шага;
//  ВложенныйКонтекстВыполнения - Неопределено или Массив - массив вложенных шагов выполнения.
//
Процедура ЗарегистрироватьКонецШагаВыполнения(ШагВыполнения, КодРезультата, ОписаниеРезультата, ВложенныйКонтекстВыполнения = Неопределено) Экспорт

	ШагВыполнения.Вставить("ВремяОкончания", ТекущаяУниверсальнаяДатаВМиллисекундах());
	ШагВыполнения.Вставить("КодРезультата", КодРезультата);
	ШагВыполнения.Вставить("ОписаниеРезультата", ОписаниеРезультата);
	ШагВыполнения.Вставить("ВложенныйКонтекстВыполнения", ВложенныйКонтекстВыполнения);

КонецПроцедуры

// Функция возвращает массив всех возможных событий журнала регистрации для событий подсистемы ОблачныйАрхив.
// Нужно для формирования журнала регистрации из Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации.
//
// Возвращаемое значение:
//   Массив - Массив всех возможных событий.
//
Функция ПолучитьСписокВсехСобытийЖурналаРегистрации() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("БИП:ОблачныйАрхив");
	Результат.Добавить("БИП:ОблачныйАрхив.Отладка");
	Результат.Добавить("БИП:ОблачныйАрхив.Сервис и регламент");
	Результат.Добавить("БИП:ОблачныйАрхив.Все обновления Облачного архива");
	Результат.Добавить("БИП:ОблачныйАрхив.Веб-сервисы");

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Скрипты

// Функция возвращает содержимое потока вывода у процесса, запущенного через WshShell.Exec(СтрокаКоманды).
//
// Параметры:
//  Процесс  - COMОбъект - объект запущенного процесса;
//  ВидПотока - Строка - "StdOut", "StdErr";
//  МаксимальноеКоличествоСтрок - Число - ограничитель возвращаемого количества строк.
//
// Возвращаемое значение:
//   Строка - содержимое потока вывода процесса.
//
Функция ПрочитатьПотокВыводаПроцесса(Процесс, ВидПотока, МаксимальноеКоличествоСтрок = 0) Экспорт

	СодержимоеПотока = "";

	Если ВРег(ВидПотока) = ВРег("StdOut") Тогда
		Поток = Процесс.StdOut;
	ИначеЕсли ВРег(ВидПотока) = ВРег("StdErr") Тогда
		Поток = Процесс.StdErr;
	Иначе
		Возврат "";
	КонецЕсли;

	ПрочитаноСтрок = 0;
	Пока НЕ Поток.AtEndOfStream Цикл
		Если МаксимальноеКоличествоСтрок > 0 Тогда
			ПрочитаноСтрок = ПрочитаноСтрок + 1;
			Если (ПрочитаноСтрок > МаксимальноеКоличествоСтрок) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		СодержимоеПотока = СодержимоеПотока + Символы.ПС + Поток.ReadLine();
	КонецЦикла;
	
	Возврат СокрЛП(СодержимоеПотока);
	
КонецФункции

// Функция возвращает таблицу с описанием всех локальных дисков (жесткие диски, USB, CD-ROM, сетевые диски).
// Так как подсистема работает только в файловой информационной базе, то неважно, где будет запускаться эта функция.
//
// Возвращаемое значение:
//   Массив - массив структур с ключами:
//    * Имя             - Строка(2) - Буква диска с двоеточием (Name);
//    * Идентификатор   - Строка(2) - Буква диска с двоеточием (DeviceID) - рекомендуется использовать для идентификации;
//    * Заголовок       - Строка(2) - Буква диска с двоеточием (Caption);
//    * ТипДиска        - Число - 2 - USB, 3 - жесткий диск, 4 - сетевой диск, 5 - CD-ROM (DriveType);
//    * ФайловаяСистема - Строка - NTFS, FAT32, ... (FileSystem);
//    * БайтВсего       - Число - Общий размер диска в байтах (Size);
//    * БайтСвободно    - Число - Свободно на диске, байт (FreeSpace);
//    * СетевойПуть     - Строка - если ТипДиска = 4, то здесь задан путь к сетевой папке (ProviderName).
//
Функция ПолучитьИнформациюОДисках()

	Результат = Новый Массив;

	wbemFlagReturnImmediately = 16;
	wbemFlagForwardOnly = 32;

	лкКомпьютер = ".";
	WMIАдрес  = "winmgmts:\\" + лкКомпьютер + "\root\CIMv2";
	WMIСервис = ПолучитьCOMОбъект(WMIАдрес);
	оЭлементы = WMIСервис.ExecQuery(
		"SELECT * FROM Win32_LogicalDisk",
		"WQL",
		wbemFlagReturnImmediately + wbemFlagForwardOnly);
	Для Каждого оЭлемент Из оЭлементы Цикл
		Результат.Добавить(
			Новый Структура("Имя, Идентификатор, Заголовок, ТипДиска, ФайловаяСистема, БайтВсего, БайтСвободно, СетевойПуть",
				оЭлемент.Name,
				оЭлемент.DeviceID,
				оЭлемент.Caption,
				оЭлемент.DriveType,
				оЭлемент.FileSystem,
				оЭлемент.Size,
				оЭлемент.FreeSpace,
				оЭлемент.ProviderName));
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Если каталог указывает на подключенный сетевой диск, то имя диска будет развернуто в полное имя.
// Было: Z:\Dir, станет \\server\path\Dir.
// Это необходимо для настроек Агента резервного копирования, т.к. пользователь может подключить сетевой диск,
//  а у пользователя, от имени которого по расписанию запускается Агент резервного копирования,
//  этот диск может быть НЕ подключен и будет ошибка копирования.
//
// Параметры:
//  ИмяКаталога - Строка - имя каталога.
//
// Возвращаемое значение:
//   Строка - преобразованное имя каталога.
//
Функция ПривестиИмяКаталогаКПолномуВиду(ИмяКаталога) Экспорт

	ВсеДиски = ПолучитьИнформациюОДисках();

	Результат = ИмяКаталога;

	Для Каждого ТекущийДиск Из ВсеДиски Цикл
		// Диск найден?
		Если ВРег(ТекущийДиск.Идентификатор) = ВРег(Лев(Результат, 2)) Тогда
			// Это подключенный сетевой диск?
			Если ТекущийДиск.ТипДиска = 4 Тогда // Сетевой диск.
				НаЧтоЗаменять = ТекущийДиск.СетевойПуть;
				Если СтрДлина(НаЧтоЗаменять) > 0 Тогда
					НаЧтоЗаменять = ИнтернетПоддержкаПользователейКлиентСервер.УдалитьПоследнийСимвол(НаЧтоЗаменять, "\/");
					Результат = ""
						+ НаЧтоЗаменять
						+ Прав(Результат, СтрДлина(Результат) - 2);
				КонецЕсли;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Агент резервного копирования не работает, если в конце имени каталога стоит косая черта.
	Результат = ИнтернетПоддержкаПользователейКлиентСервер.УдалитьПоследнийСимвол(Результат, "\/");

	Возврат Результат;

КонецФункции

// Возвращает признак, с какими привилегиями запущено приложение 1С.
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//   Число - 0, если приложение запущено с административными привилегиями;
//           2, если приложение запущено с пользовательскими привилегиями;
//           9996, другая ошибка;
//           9997, код возврата не похож на число;
//           9998, если результат по каким-то причинам не сформирован;
//           9999, если работаем в веб-клиенте;
//           Иначе - другой код ошибки.
//
Функция ЭтоАдминистраторWindows() Экспорт

	Результат = 9999;

	#Если НЕ ВебКлиент Тогда

	ИмяКомандногоФайла = ПолучитьИмяВременногоФайла("cmd");
	ИмяФайлаВывода     = ПолучитьИмяВременногоФайла("txt");

	ЕстьОшибки = Ложь;
	Попытка
		// 1. Создадим cmd-файл.
		Текст = Новый ТекстовыйДокумент;
		Текст.ДобавитьСтроку("@echo off");
		// Вызывать два раза, т.к. если кто-то запустил "at" до этого, то net session сработает неправильно.
		Текст.ДобавитьСтроку("chcp 1251"); // Если в имени каталога есть кириллица, то надо корректно это отработать.
		Текст.ДобавитьСтроку("net session >nul 2>nul");
		Текст.ДобавитьСтроку("net session >nul 2>nul");
		Текст.ДобавитьСтроку("echo %errorlevel% > " + ИмяФайлаВывода);
		Текст.Записать(ИмяКомандногоФайла, КодировкаТекста.ANSI, Символы.ПС);

		// 2. Запустим cmd-файл так, чтобы не показывалось консольное окно.
		НачалоВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();
		// Режимы вывода окна:
		// 0 - Hides the window and activates another window.
		// 1 - Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. An application should specify this flag when displaying the window for the first time.
		// 2 - Activates the window and displays it as a minimized window. 
		// 3 - Activates the window and displays it as a maximized window. 
		// 4 - Displays a window in its most recent size and position. The active window remains active.
		// 5 - Activates the window and displays it in its current size and position.
		// 6 - Minimizes the specified window and activates the next top-level window in the Z order.
		// 7 - Displays the window as a minimized window. The active window remains active.
		// 8 - Displays the window in its current state. The active window remains active.
		// 9 - Activates and displays the window. If the window is minimized or maximized, the system restores it to its original size and position. An application should specify this flag when restoring a minimized window.
		// 10 - Sets the show-state based on the state of the program that started the application.
		РежимВыводаОкна = 0;
		ОбъектОболочка = Новый COMОбъект("WScript.Shell");
		ОбъектОболочка.Run(ИмяКомандногоФайла, РежимВыводаОкна, 1); // Не показывать окно, дождаться завершения.
		КонецВыполнения = ТекущаяУниверсальнаяДатаВМиллисекундах();

	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Результат = 9996;
		ЕстьОшибки = Истина;
	КонецПопытки;

	Если ЕстьОшибки = Ложь Тогда

		// 3. Прочитать содержимое файла вывода.
		ФайлВывода = Новый Файл(ИмяФайлаВывода);
		Если ФайлВывода.Существует() Тогда

			ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаВывода, КодировкаТекста.ANSI, Символы.ПС, Символы.ПС, Ложь);
			ВесьТекст = ЧтениеТекста.Прочитать();
			ЧтениеТекста.Закрыть();
			Если СтрЧислоСтрок(ВесьТекст) >= 1 Тогда
				ПерваяСтрока = СтрПолучитьСтроку(ВесьТекст, 1);
				Попытка
					Результат = Число(ПерваяСтрока);
				Исключение
					Результат = 9997;
				КонецПопытки;
			Иначе
				Результат = 9998;
			КонецЕсли;

		Иначе
			Результат = 9996;
		КонецЕсли;

	КонецЕсли;

	// 4. Удалить временные файлы.
	Попытка
		УдалитьФайлы(ИмяКомандногоФайла);
		УдалитьФайлы(ИмяФайлаВывода);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;

	#КонецЕсли

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СписокИдентификаторовИБ

// В облачный архив будут попадать резервные копии с разными идентификаторами:
//  ОсновнойИдентификатор + Суффикс, что позволит разделять копии по способу создания для дальнейшей обработки.
// Основные суффиксы: Auto (автоматические резервные копии) и Manual (ручные резервные копии), и итоговые идентификаторы примут вид:
//  - 000000000000000000000_Auto и 000000000000000000000_Manual, где 000000000000000000000 - идентификатор этой ИБ.
//
// Возвращаемое значение:
//  Структура - Структура с ключами:
//   * Ключ - Строка - Суффикс, добавляемый к основному идентификатору ИБ (состоит из английских букв, цифр, знаков "-" и "_", в верхнем регистре);
//   * Значение - Структура - структура с ключами:
//     ** Суффикс  - Строка - суффикс, добавляемый к идентификатору ИБ для резервных копий;
//     ** Описание - Строка - текст, добавляемый к имени ИБ для резервных копий.
//
Функция ПолучитьСтруктуруСуффиксовИдентификаторовИБ() Экспорт

	ТипСтруктура = Тип("Структура");

	Результат = Новый Структура;

	ОблачныйАрхивКлиентСерверПереопределяемый.ДополнитьСтруктуруСуффиксовИдентификаторовИБ(Результат);

	Если ТипЗнч(Результат) <> ТипСтруктура Тогда
		Результат = Новый Структура;
	КонецЕсли;

	Результат.Вставить("АвтоматическаяКопия",
			Новый Структура("Суффикс, Описание",
				"_Auto",
				"")); // Никакого дополнительного описания.
	Результат.Вставить("РучнаяКопия",
			Новый Структура("Суффикс, Описание",
				"_Manual",
				НСтр("ru=' (вручную)'")));

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
