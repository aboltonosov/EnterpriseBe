﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммы.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет возможность использования автоматического обновления программы в
// текущем режиме работы.
//
// Параметры:
//	ПроверитьВозможностьПримененияОбновлений - Булево - проверить для текущего
//		пользователя наличие права применения обновления.
//		Если Истина - проверяется возможность использования в режиме применения
//		обновления, иначе проверить возможность просмотра информации о
//		доступных обновлениях;
//	ПроверитьОС - Булево - проверить возможность применения обновления
//		на текущей операционной системе.
//
// Возвращаемое значение:
//	Булево - признак возможности использования: Истина, если использование
//		возможно, Ложь - в противном случае.
//
Функция ДоступноИспользованиеОбновленияПрограммы(
	ПроверитьВозможностьПримененияОбновлений = Ложь,
	ПроверитьОС = Истина) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент()
		Или ОбщегоНазначенияПовтИсп.РазделениеВключено()
		Или (ПроверитьВозможностьПримененияОбновлений И Не Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь))
		Или Не Пользователи.РолиДоступны("ПросмотрИнформацииОДоступныхОбновленияхПрограммы", , Ложь)
		Или ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя()
		Или ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПроверитьОС И Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо использовать функцию
// ДоступноИспользованиеОбновленияПрограммы().
// Определяет возможность использования механизма автоматического обновления
// платформы 1С:Предприятие в текущем режиме работы.
//
// Возвращаемое значение:
//	Булево - признак возможности использования: Истина, если использование
//		возможно, Ложь - в противном случае.
//
Функция ДоступноИспользованиеПолученияОбновленийПлатформы() Экспорт
	
	Возврат СлужебнаяДоступноИспользованиеПолученияОбновленийПлатформы();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет описание обработчиков событий, реализуемых подсистемой.
//
// Описание формата процедур-обработчиков см. в описании функции
// ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ОбработчикиСобытий().
//
// Параметры:
//	СерверныеОбработчики - Структура - серверные обработчики;
//		* ПараметрыРаботыКлиентаПриЗапуске - Массив - элементы типа Строка -
//			имена модулей, реализующих обработку заполнения параметров
//			работы клиента при запуске;
//		* ОчиститьНастройкиИПППользователя - элементы типа Строка -
//			имена модулей, реализующих обработку очистки настроек
//			пользователя при выходе авторизованного пользователя из ИПП;
//		* БизнесПроцессы - Соответствие - серверные обработчики
//			бизнес-процессов:
//			** Ключ - Строка - <Точка входа бизнес-процесса>\<Имя события>;
//			** Значение - Строка - имя серверного модуля, реализующего
//				обработчик бизнес-процесса;
//	КлиентскиеОбработчики - Структура - клиентские обработчики;
//		* ПриНачалеРаботыСистемы - элементы типа Строка -
//			имена клиентских модулей, реализующих обработку
//			события "При начале работы системы"
//		* БизнесПроцессы - Соответствие - клиентские обработчики
//			бизнес-процессов:
//			** Ключ - Строка - <Точка входа бизнес-процесса>\<Имя события>;
//			** Значение - Строка - имя клиентского модуля, реализующего
//				обработчик бизнес-процесса;
//
Процедура ДобавитьОбработчикиСобытий(СерверныеОбработчики, КлиентскиеОбработчики) Экспорт
	
	СерверныеОбработчики.ПараметрыРаботыКлиентаПриЗапуске.Добавить("ПолучениеОбновленийПрограммы");
	КлиентскиеОбработчики.ПриНачалеРаботыСистемы.Добавить("ПолучениеОбновленийПрограммыКлиент");
	
КонецПроцедуры

// Добавляет необходимые параметры работы клиента при запуске.
// Добавленные параметры доступны в
// СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ИнтернетПоддержкаПользователей.<ИмяПараметра>;
// Используется в том случае, если подсистема реализует сценарий, выполняемый
// при начале работы системы.
// Вызывается из ИнтернетПоддержкаПользователей.ПараметрыРаботыКлиентаПриЗапуске().
//
// Параметры:
//	Параметры - Структура - заполняемые параметры;
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если Не ДоступноИспользованиеОбновленияПрограммы() Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОбновления = НастройкиАвтоматическогоОбновления();
	Параметры.Вставить("ПолучениеОбновленийПрограммы", НастройкиОбновления);
	
КонецПроцедуры

// Интеграция с подсистемой СтандартныеПодсистемы.ТекущиеДела.
// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Не ПолучениеОбновленийПрограммыКлиентСервер.ВстроенаПодсистемаТекущиеДела()
		Или Не ДоступноИспользованиеОбновленияПрограммы() Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторДела = "ОбновлениеПрограммы";
	
	// Вызов процедуры предполагает наличие подсистемы СтандартныеПодсистемы.ТекущиеДела.
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Если МодульТекущиеДелаСервер.ДелоОтключено(ИдентификаторДела) Тогда
		Возврат;
	КонецЕсли;
	
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Обработки.ОбновлениеПрограммы.ПолноеИмя());
	Если Разделы.Количество() > 0 Тогда
		
		ИнформацияОДоступномОбновленииВНастройках = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ИнтеррнетПоддержка",
			"ПолучениеОбновленийПрограммы/ИнформацияОДоступномОбновлении");
		
		Если ТипЗнч(ИнформацияОДоступномОбновленииВНастройках) <> Тип("Структура")
			Или Не ИнформацияОДоступномОбновленииВНастройках.Свойство("ИмяПрограммы")
			Или ИнформацияОДоступномОбновленииВНастройках.ИмяПрограммы <> ИнтернетПоддержкаПользователейКлиентСервер.ИмяПрограммы()
			Или Не ИнформацияОДоступномОбновленииВНастройках.Свойство("МетаданныеИмя")
			Или ИнформацияОДоступномОбновленииВНастройках.МетаданныеИмя <> ИнтернетПоддержкаПользователейКлиентСервер.ИмяКонфигурации()
			Или Не ИнформацияОДоступномОбновленииВНастройках.Свойство("МетаданныеВерсия")
			Или ИнформацияОДоступномОбновленииВНастройках.МетаданныеВерсия <> ИнтернетПоддержкаПользователейКлиентСервер.ВерсияКонфигурации()
			Или Не ИнформацияОДоступномОбновленииВНастройках.Свойство("ВерсияПлатформы")
			Или ИнформацияОДоступномОбновленииВНастройках.ВерсияПлатформы <> ПолучениеОбновленийПрограммыКлиентСервер.ТекущаяВерсияПлатформы1СПредприятие()
			Или Не ИнформацияОДоступномОбновленииВНастройках.Свойство("ИнформацияОДоступномОбновлении")
			Или ТипЗнч(ИнформацияОДоступномОбновленииВНастройках.ИнформацияОДоступномОбновлении) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		ИнформацияОДоступномОбновлении = ИнформацияОДоступномОбновленииВНастройках.ИнформацияОДоступномОбновлении;
		
		Если Не ПустаяСтрока(ИнформацияОДоступномОбновлении.ИмяОшибки) Тогда
			
			Для Каждого Раздел Из Разделы Цикл
				Дело = ТекущиеДела.Добавить();
				Дело.Идентификатор  = ИдентификаторДела;
				Дело.ЕстьДела       = Истина;
				Дело.Важное         = Истина;
				Дело.Представление  = НСтр("ru = 'Не удалось проверить наличие обновлений программы.'");
				Дело.Форма          = "Обработка.ОбновлениеПрограммы.Форма.Форма";
				Дело.ПараметрыФормы = Новый Структура("ИнформацияОбОбновлении", ИнформацияОДоступномОбновлении);
				Дело.Владелец       = Раздел;
			КонецЦикла;
			
		ИначеЕсли ИнформацияОДоступномОбновлении.ДоступноОбновление Тогда
			
			ЭтоФайловаяИБ = ЭтоФайловаяИБ();
			ОбновлениеКомКонф = ИнформацияОДоступномОбновлении.Конфигурация;
			ОбновлениеКомПл   = ИнформацияОДоступномОбновлении.Платформа;
			РазмерОбновления = ?(ОбновлениеКомКонф.ДоступноОбновление, ОбновлениеКомКонф.РазмерОбновления, 0)
				+ ?(ОбновлениеКомПл.ДоступноОбновление И ЭтоФайловаяИБ
					И (Не ОбновлениеКомКонф.ДоступноОбновление Или ОбновлениеКомПл.ОбязательностьУстановки < 2),
					ОбновлениеКомПл.РазмерОбновления,
					0);
			РекомендуетсяУстановить = (Не ОбновлениеКомКонф.ДоступноОбновление
				И ОбновлениеКомПл.ДоступноОбновление
				И ОбновлениеКомПл.ОбязательностьУстановки < 2);
			
			Если РазмерОбновления <> 0 Тогда
				ПредставлениеДелаРазмер =
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Размер дистрибутива: %1.'"),
						ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеРазмераФайла(РазмерОбновления));
			КонецЕсли;
			
			Для Каждого Раздел Из Разделы Цикл
				
				Дело = ТекущиеДела.Добавить();
				Дело.Идентификатор  = ИдентификаторДела;
				Дело.ЕстьДела       = Истина;
				Дело.Важное         = РекомендуетсяУстановить;
				Дело.Представление  = НСтр("ru = 'Доступно обновление программы'");
				Дело.Форма          = "Обработка.ОбновлениеПрограммы.Форма.Форма";
				Дело.ПараметрыФормы = Новый Структура("ИнформацияОбОбновлении", ИнформацияОДоступномОбновлении);
				Дело.Владелец       = Раздел;
				
				Если РазмерОбновления <> 0 Тогда
					
					ДелоРазмер = ТекущиеДела.Добавить();
					ДелоРазмер.Идентификатор  = "РазмерОбновленияПрограммы";
					ДелоРазмер.ЕстьДела       = Истина;
					ДелоРазмер.Представление  = ПредставлениеДелаРазмер;
					ДелоРазмер.Владелец       = ИдентификаторДела;
					
				КонецЕсли;
				
				Если РекомендуетсяУстановить Тогда
					
					ДелоРекомендуетсяУстановить = ТекущиеДела.Добавить();
					ДелоРекомендуетсяУстановить.Идентификатор  = "РекомендацияУстановитьОбновленияПрограммы";
					ДелоРекомендуетсяУстановить.ЕстьДела       = Истина;
					ДелоРекомендуетсяУстановить.Представление  = НСтр("ru = 'Рекомендуется установить это обновление.'");
					ДелоРекомендуетсяУстановить.Владелец       = ИдентификаторДела;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Интеграция с подсистемой СтандартныеПодсистемы.БазоваяФункциональность.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		НовыеРазрешения = Новый Массив;
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTP",
			"downloads.v8.1c.ru",
			80,
			НСтр("ru = 'Получение файлов обновлений программы (зона ru)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTP",
			"downloads.v8.1c.eu",
			80,
			НСтр("ru = 'Получение файлов обновлений программы (зона eu)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"update-api.1c.ru",
			443,
			НСтр("ru = 'Сервис получения обновлений программы (зона ru)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"update-api.1c.eu",
			443,
			НСтр("ru = 'Сервис получения обновлений программы (зона eu)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список обработчиков обновления информационной базы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "2.1.8.1";
	Обработчик.Процедура =
		"ПолучениеОбновленийПрограммы.ОбновлениеИнформационнойБазы_ОбновитьНастройкиПолученияОбновлений_2_1_8_1";
	Обработчик.ОбщиеДанные         = Ложь;
	Обработчик.НачальноеЗаполнение = Ложь;
	Обработчик.РежимВыполнения     = "Оперативно";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоФайловаяИБ() Экспорт
	
	Возврат ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
КонецФункции

Функция ЭтоАдминистраторСистемы() Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь);
	
КонецФункции

Функция ЭтоБазоваяВерсияКонфигурации() Экспорт
	
	Возврат СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
КонецФункции

Функция СлужебнаяДоступноИспользованиеПолученияОбновленийПлатформы(
	ПроверитьВозможностьАвтоматическойУстановки = Ложь) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент()
		Или ОбщегоНазначенияПовтИсп.РазделениеВключено()
		Или Не Пользователи.ЭтоПолноправныйПользователь(, Истина)
		Или ПроверитьВозможностьАвтоматическойУстановки И Не ЭтоФайловаяИБ()
		Или ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СистИнфо = Новый СистемнаяИнформация;
	Если СистИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86
		И СистИнфо.ТипПлатформы <> ТипПлатформы.Windows_x86_64 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Проверка наличия обновлений в фоновом режиме.
// Получение и установка обновлений в фоновом режиме.

Процедура ПроверитьНаличиеОбновленияВФоновомРежиме(ПараметрыКлиента) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыКлиента", ПараметрыКлиента);
	ИнформацияОДоступномОбновлении = ПолучениеОбновленийПрограммыКлиентСервер.ИнформацияОДоступномОбновлении(
		ИнтернетПоддержкаПользователейКлиентСервер.ИмяПрограммы(),
		ИнтернетПоддержкаПользователейКлиентСервер.ВерсияКонфигурации(),
		Неопределено,
		Неопределено,
		"РабочееОбновление",
		ДополнительныеПараметры);
	
	СообщитьСостояние("Выполнено", , ИнформацияОДоступномОбновлении);
	
КонецПроцедуры

Процедура ЗагрузитьИУстановитьОбновленияВФоновомРежиме(Параметры) Экспорт
	
	Если Не ДоступноИспользованиеОбновленияПрограммы(Истина, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Использование обновления программы недоступно в текущем режиме работы.'");
	КонецЕсли;
	
	Контекст = Параметры.КонтекстОбновления;
	Если Контекст = Неопределено Тогда
		Контекст = ПолучениеОбновленийПрограммыКлиентСервер.НовыйКонтекстПолученияИУстановкиОбновлений(Параметры);
	Иначе
		// Сброс состояния ошибки.
		Контекст.Вставить("ИмяОшибки"         , "");
		Контекст.Вставить("Сообщение"         , "");
		Контекст.Вставить("ИнформацияОбОшибке", "");
	КонецЕсли;
	
	ПолученоФайлов        = 0;
	ОбъемПолученныхФайлов = 0;
	
	// 1) Получение файла обновления платформы.
	Если Контекст.ОбновитьПлатформу Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Получение обновления платформы 1С:Предприятие: версия %1; URL: %2'"),
				Контекст.ВерсияПлатформы,
				Контекст.URLФайлаОбновленияПлатформы));
		
		Если Не ПустаяСтрока(Контекст.КаталогДистрибутиваПлатформы) Тогда
			
			ПолученоФайлов        = 1;
			ОбъемПолученныхФайлов = ОбъемПолученныхФайлов + Контекст.РазмерОбновленияПлатформы;
			
			ЗаписатьИнформациюВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Обновление платформы 1С:Предприятие уже было загружено ранее в %1'"),
					Контекст.КаталогДистрибутиваПлатформы));
			
		Иначе
			
			КаталогУстановкиПлатформы = ПолучениеОбновленийПрограммыКлиентСервер.КаталогУстановкиПлатформы1СПредприятие(
				Контекст.ВерсияПлатформы);
			Если КаталогУстановкиПлатформы <> Неопределено Тогда
				
				// Платформа уже установлена.
				ПолученоФайлов        = 1;
				ОбъемПолученныхФайлов = ОбъемПолученныхФайлов + Контекст.РазмерОбновленияПлатформы;
				Контекст.Вставить("ОбновлениеПлатформыУстановлено", Истина);
				
				ЗаписатьИнформациюВЖурналРегистрации(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Версия %1 платформы 1С:Предприятие уже установлена на компьютере.'"),
						Контекст.ВерсияПлатформы));
				
			Иначе
				
				// Загрузить файл платформы.
				Контекст.ТекущееДействие =
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Получение файла %1 из %2'"),
						Строка(ПолученоФайлов + 1),
						Контекст.КоличествоФайлов);
				СообщитьСостояние("ПолучениеФайлов", , Контекст);
				
				ЗагрузитьОбновлениеПлатформы(Контекст, Параметры);
				Если Не ПустаяСтрока(Контекст.ИмяОшибки) Тогда
					// Ошибка загрузки платформы.
					СообщитьСостояние("Ошибка", , Контекст);
					Возврат;
				Иначе
					ПолученоФайлов        = 1;
					ОбъемПолученныхФайлов = ОбъемПолученныхФайлов + Контекст.РазмерОбновленияПлатформы;
					Контекст.Прогресс = 85 * (ОбъемПолученныхФайлов / Контекст.ОбъемФайлов);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// 2) Получение файлов обновления конфигурации.
	Для каждого ТекОбновление Из Контекст.ОбновленияКонфигурации Цикл
		
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Получение обновления конфигурации.
					|URL: %1;
					|Размер: %2;
					|Формат файла обновления: %3;
					|Контрольная сумма файла обновления: %4;
					|Каталог дистрибутива: %5;
					|Выполнить обработчики обновления: %6;
					|Имя файла обновления (cfu): %7.'"),
				ТекОбновление.URLФайлаОбновления,
				ТекОбновление.РазмерФайла,
				ТекОбновление.ФорматФайлаОбновления,
				ТекОбновление.КонтрольнаяСумма,
				ТекОбновление.КаталогДистрибутива,
				ТекОбновление.ПрименитьОбработчикиОбновления,
				ТекОбновление.ОтносительныйПутьCFUФайла));
		
		Если Не ПолучениеОбновленийПрограммыКлиентСервер.ОбновлениеКонфигурацииПолучено(ТекОбновление, Контекст) Тогда
			
			Контекст.ТекущееДействие =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Получение файла %1 из %2'"),
					Строка(ПолученоФайлов + 1),
					Контекст.КоличествоФайлов);
			Контекст.Прогресс = 85 * (ОбъемПолученныхФайлов / Контекст.ОбъемФайлов);
			СообщитьСостояние("ПолучениеФайлов", , Контекст);
			
			ЗагрузитьОбновлениеКонфигурации(ТекОбновление, Контекст, Параметры);
			Если Не ПустаяСтрока(Контекст.ИмяОшибки) Тогда
				СообщитьСостояние("Ошибка", , Контекст);
				Возврат;
			КонецЕсли;
			
		Иначе
			
			ЗаписатьИнформациюВЖурналРегистрации(
				НСтр("ru = 'Обновление конфигурации уже было получено ранее.'"));
			
		КонецЕсли;
		
		ПолученоФайлов        = ПолученоФайлов + 1;
		ОбъемПолученныхФайлов = ОбъемПолученныхФайлов + ТекОбновление.РазмерФайла;
		
	КонецЦикла;
	
	
	Контекст.ФайлыОбновленияПолучены = Истина;
	
	// 3) Установка платформы.
	Если Контекст.ОбновитьПлатформу И Не Контекст.ОбновлениеПлатформыУстановлено Тогда
		
		Контекст.Прогресс        = 85;
		Контекст.ТекущееДействие = НСтр("ru = 'Установка платформы 1С:Предприятие'");
		СообщитьСостояние("УстановкаПлатформы", , Контекст);
		
		УстановкаОтменена = Ложь;
		УстановитьОбновлениеПлатформы(Контекст, Параметры, УстановкаОтменена);
		Если УстановкаОтменена Тогда
			
			СообщитьСостояние("УстановкаПлатформыОтменена", , Контекст);
			Возврат;
			
		ИначеЕсли Не ПустаяСтрока(Контекст.ИмяОшибки) Тогда
			
			// Ошибка установки платформы.
			СообщитьСостояние("Ошибка", , Контекст);
			Возврат;
			
		Иначе
			
			Контекст.ОбновлениеПлатформыУстановлено = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Контекст.Прогресс  = 100;
	Контекст.Завершено = Истина;
	СообщитьСостояние("Завершено", , Контекст);
	
КонецПроцедуры

Процедура ЗагрузитьОбновлениеПлатформы(Контекст, Параметры)
	
	КаталогДляЗагрузки = ПолучениеОбновленийПрограммыКлиентСервер.КаталогДляРаботыСОбновлениямиПлатформы();
	КаталогХраненияДистрибутивов = Параметры.КаталогХраненияДистрибутивовПлатформы;
	
	Если КаталогХраненияДистрибутивов = Неопределено Тогда
		КаталогДистрибутива = КаталогДляЗагрузки + "setup\";
	Иначе
		Если Прав(КаталогХраненияДистрибутивов, 1) <> "\" Тогда
			КаталогХраненияДистрибутивов = КаталогХраненияДистрибутивов + "\";
		КонецЕсли;
		КаталогДистрибутива = КаталогХраненияДистрибутивов + Контекст.ВерсияПлатформы + "\";
	КонецЕсли;
	
	// Проверить наличие загруженного дистрибутива.
	ДистрибутивЗагружен = ПолучениеОбновленийПрограммыКлиентСервер.КаталогСодержитДистрибутивПлатформы1СПредприятие(
		КаталогДистрибутива,
		Контекст.ВерсияПлатформы);
	
	// Загрузка дистрибутива.
	Если ДистрибутивЗагружен Тогда
		Контекст.КаталогДистрибутиваПлатформы = КаталогДистрибутива;
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обновление платформы 1С:Предприятие уже было загружено ранее в %1'"),
				Контекст.КаталогДистрибутиваПлатформы));
		Возврат;
	КонецЕсли;
	
	Попытка
		СоздатьКаталог(КаталогДистрибутива);
	Исключение
		
		ИнфОшибка = ИнформацияОбОшибке();
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при создании каталога для сохранения дистрибутива (%1).'"),
				КаталогДистрибутива)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнфОшибка);
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива. %2'"),
			КаталогДистрибутива,
			КраткоеПредставлениеОшибки(ИнфОшибка));
		Возврат;
		
	КонецПопытки;
	
	Попытка
		СоздатьКаталог(КаталогДляЗагрузки);
	Исключение
		
		ИнфОшибка = ИнформацияОбОшибке();
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при создании каталога для загрузки дистрибутива (%1).'"),
				КаталогДляЗагрузки)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнфОшибка);
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива. %2'"),
			КаталогДляЗагрузки,
			КраткоеПредставлениеОшибки(ИнфОшибка));
		Возврат;
		
	КонецПопытки;
	
	// Загрузка файла.
	ПутьПолученногоФайла = КаталогДляЗагрузки + "setup.zip";
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получение файла обновления платформы 1С:Предприятие: %1'"),
			ПутьПолученногоФайла));
	
	ДопПараметры = Новый Структура("ИмяФайлаОтвета, Таймаут", ПутьПолученногоФайла, 0);
	РезультатПолучения = ИнтернетПоддержкаПользователейКлиентСервер.ЗагрузитьСодержимоеИзИнтернет(
		Контекст.URLФайлаОбновленияПлатформы,
		Параметры.Логин,
		Параметры.Пароль,
		ДопПараметры);
	
	Если Не ПустаяСтрока(РезультатПолучения.КодОшибки) Тогда
		
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при получении файла дистрибутива платформы 1С:Предприятие (%1). %2'"),
				Контекст.URLФайлаОбновленияПлатформы,
				РезультатПолучения.ИнформацияОбОшибке);
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = РезультатПолучения.КодОшибки;
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при получении файла дистрибутива. %1'"),
			РезультатПолучения.СообщениеОбОшибке);
		Если ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(ПутьПолученногоФайла, Ложь) Тогда
			Попытка
				УдалитьФайлы(ПутьПолученногоФайла);
			Исключение
				ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл обновления платформы 1С:Предприятие успешно получен: %1'"),
			ПутьПолученногоФайла));
	
	// Извлечение файлов.
	Попытка
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Извлечение дистрибутива платформы 1С:Предприятие в %1'"),
				КаталогДистрибутива));
		ЧтениеZIP = Новый ЧтениеZipФайла(ПутьПолученногоФайла);
		ЧтениеZIP.ИзвлечьВсе(КаталогДистрибутива, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Исключение
		
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при извлечении файлов архива (%1) в каталог %2.'"),
				ПутьПолученногоФайла,
				КаталогДистрибутива)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки          = "ОшибкаИзвлеченияДанныхИзФайла";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось извлечь файлы дистрибутива. %1'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
		
	КонецПопытки;
	
	ЧтениеZIP.Закрыть();
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дистрибутив платформы 1С:Предприятие успешно сохранен в %1'"),
			КаталогДистрибутива));
	
	СохранитьКаталогПоследнегоПолученногоДистрибутиваПлатформы(КаталогДистрибутива);
	Контекст.КаталогДистрибутиваПлатформы = КаталогДистрибутива;
	
КонецПроцедуры

Процедура УстановитьОбновлениеПлатформы(Контекст, Параметры, УстановкаОтменена)
	
	// Подготовка протокола установки.
	КаталогДляЗагрузки  = ПолучениеОбновленийПрограммыКлиентСервер.КаталогДляРаботыСОбновлениямиПлатформы();
	КаталогДистрибутива = Контекст.КаталогДистрибутиваПлатформы;
	
	ПутьФайлаПротокола = КаталогДляЗагрузки + "installlog.txt";
	Контекст.Вставить("ПутьФайлаПротокола", ПутьФайлаПротокола);
	
	Если ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(ПутьФайлаПротокола) Тогда
		Попытка
			УдалитьФайлы(ПутьФайлаПротокола);
		Исключение
			ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при удалении файла протокола (%1). %2'"),
					ПутьФайлаПротокола,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		КонецПопытки;
	КонецЕсли;
	
	
	// Запуск установки.
	КодВозврата = 0;
	ПутьФайлаПрограммыУстановки = КаталогДистрибутива + "setup.exe";
	Если Не ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(ПутьФайлаПрограммыУстановки) Тогда
		
		СообщениеЖурнала = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загружен некорректный дистрибутив платформы 1С:Предприятие. Отсутствует файл setup.exe (%1).'"),
			ПутьФайлаПрограммыУстановки);
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "НекорректныйДистрибутивПлатформы";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = НСтр("ru = 'Загружен некорректный дистрибутив платформы 1С:Предприятие. Отсутствует файл setup.exe.'");
		Возврат;
		
	КонецЕсли;
	
	Попытка
		
		ПутьФайлаПрограммыУстановки = """" + КаталогДистрибутива + "setup.exe""";
		КомандаЗапуска = ПутьФайлаПрограммыУстановки + " "
			+ ?(Параметры.РежимУстановкиПлатформы = 0, " /S ", "") // "Тихий" или полный режим
			+ "/debuglog installlog.txt"; // Протокол установки
		
		ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Установка новой версии платформы 1С:Предприятие (%1). %2'"),
				Контекст.ВерсияПлатформы,
				КомандаЗапуска));
		
		ЗапуститьПриложение(КомандаЗапуска, КаталогДляЗагрузки, Истина, КодВозврата);
		
	Исключение
		
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при запуске программы установки платформы 1С:Предприятие (%1). %2'"),
				КомандаЗапуска,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаУстановкиПлатформы";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при запуске программы установки платформы 1С:Предприятие. %1'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
		
	КонецПопытки;
	
	Контекст.КодВозвратаПрограммыУстановки = КодВозврата;
	
	Если КодВозврата = 0 Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Новая версия платформы 1С:Предприятие успешно установлена.'"));
		
	Иначе
		
		Если КодВозврата = 1602 Тогда
			
			// Отменено пользователем.
			УстановкаОтменена = Истина;
			
		Иначе
			
			// Обработка прочих кодов возврата.
			СообщениеЖурнала =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Установка платформы 1С:Предприятие завершена с ошибкой.
						|Версия %1;
						|Код возврата: %2;
						|Команда: %3'"),
					Контекст.ВерсияПлатформы,
					Строка(КодВозврата),
					КомандаЗапуска);
			ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
			
			ШаблонСообщенияПользователю =
				НСтр("ru = '<body>При установке новой версии платформы 1С:Предприятие произошла ошибка.
					|<br />Код возврата: %1.'");
			
			Если ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(ПутьФайлаПротокола) Тогда
				ШаблонСообщенияПользователю = ШаблонСообщенияПользователю + Символы.ПС
					+ НСтр("ru = '<br />Техническая информация содержится в <a href=""open:debuglog"">протоколе установки</a>.'");
			КонецЕсли;
			
			Если Параметры.РежимУстановкиПлатформы = 0
				И ПолучениеОбновленийПрограммыКлиентСервер.ЭтоКодВозвратаОграниченияСистемныхПолитик(КодВозврата) Тогда
				// При ошибке ограничений системных политик установки в тихом режиме
				// предложить пользователю выполнить установку в полном интерактивном режиме.
				ШаблонСообщенияПользователю = ШаблонСообщенияПользователю + Символы.ПС
					+ НСтр("ru = '<br /><br /><p>Данная ошибка связана с ограничениями системных политик безопасности.
						|<br />Рекомендуется установить платформу с ручными настройками.</p>'");
			КонецЕсли;
			
			ШаблонСообщенияПользователю = ШаблонСообщенияПользователю + Символы.ПС
				+ НСтр("ru = '<br /><br />При возникновении проблем напишите в <a href=""mailto:webits-info@1c.ru"">техподдержку</a>.</body>'");
			
			Контекст.ИмяОшибки = "ОшибкаУстановкиПлатформы";
			Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
			Контекст.Сообщение = ИнтернетПоддержкаПользователейКлиентСервер.ПодставитьДомен(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщенияПользователю,
					Строка(КодВозврата)));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьОбновлениеКонфигурации(Обновление, Контекст, Параметры)
	
	// Создание каталогов.
	ПолучениеОбновленийПрограммыКлиентСервер.СоздатьКаталогиДляПолученияОбновления(Обновление, Контекст);
	
	Если Не ПустаяСтрока(Контекст.ИмяОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	// Загрузка файла.
	ДопПараметры = Новый Структура("ИмяФайлаОтвета, Таймаут", Обновление.ИмяПолученногоФайла, 0);
	
	ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файла обновления конфигурации %1'"),
			Обновление.ИмяПолученногоФайла));
	
	РезультатПолучения = ИнтернетПоддержкаПользователейКлиентСервер.ЗагрузитьСодержимоеИзИнтернет(
		Обновление.URLФайлаОбновления,
		Параметры.Логин,
		Параметры.Пароль,
		ДопПараметры);
	
	Если Не ПустаяСтрока(РезультатПолучения.КодОшибки) Тогда
		
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при получении файла дистрибутива конфигурации (%1). %2'"),
				Обновление.URLФайлаОбновления,
				РезультатПолучения.ИнформацияОбОшибке);
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = РезультатПолучения.КодОшибки;
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при получении файла дистрибутива конфигурации. %1'"),
			РезультатПолучения.СообщениеОбОшибке);
		Если ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(Обновление.ИмяПолученногоФайла, Ложь) Тогда
			Попытка
				УдалитьФайлы(Обновление.ИмяПолученногоФайла);
			Исключение
				ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Файл обновления успешно загружен.'"));
	ПолучениеОбновленийПрограммыКлиентСервер.ЗавершитьПолучениеОбновления(Обновление, Контекст);
	Обновление.Получено = Истина;
	
КонецПроцедуры

Процедура СообщитьСостояние(
	КодСостояния,
	Сообщение = "",
	ДопПараметры = Неопределено,
	СообщениеЖурналаРегистрации = Неопределено)
	
	ОписательСостояния = Новый Структура("КодСостояния, ДопПараметры", КодСостояния, ДопПараметры);
	Если СообщениеЖурналаРегистрации <> Неопределено Тогда
		ОписательСостояния.Вставить("СообщениеЖурналаРегистрации", СообщениеЖурналаРегистрации);
	КонецЕсли;
	
	ДлительныеОперации.СообщитьПрогресс(
		,
		Сообщение,
		ОписательСостояния);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Персональные настройки пользователя

Функция НастройкиАвтоматическогоОбновления() Экспорт
	
	Результат = ПолучениеОбновленийПрограммыКлиентСервер.НовыйНастройкиАвтоматическогоОбновления();
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеррнетПоддержка",
		"ПолучениеОбновленийПрограммы");
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Результат, Настройки);
		Если Настройки.Свойство("СпособАвтоматическойПроверки") Тогда
			Результат.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = Настройки.СпособАвтоматическойПроверки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьНастройкиАвтоматическогоОбновления(Настройки) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеррнетПоддержка",
		"ПолучениеОбновленийПрограммы",
		Настройки);
	
КонецПроцедуры

Функция КаталогСохраненияПоследнегоПолученногоДистрибутива() Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ИнтеррнетПоддержка",
			"КаталогДистрибутива");
	
КонецФункции

Процедура СохранитьКаталогПоследнегоПолученногоДистрибутиваПлатформы(Каталог)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеррнетПоддержка",
		"КаталогДистрибутива",
		Каталог);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

Процедура ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ПолучениеОбновленийПрограммыКлиентСервер.ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		СообщениеОбОшибке);
	
КонецПроцедуры

Процедура ЗаписатьИнформациюВЖурналРегистрации(Сообщение) Экспорт
	
	ЗаписьЖурналаРегистрации(
		ПолучениеОбновленийПрограммыКлиентСервер.ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		Сообщение);
	
КонецПроцедуры

Функция ДополнительныеПараметрыЗапросаКСервисуОбновлений(ПараметрыКлиента = Неопределено) Экспорт
	
	Возврат ИнтернетПоддержкаПользователей.ДополнительныеПараметрыВызоваОперацииСервиса();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление данных информационной базы.

// Преобразует пользовательские настройки подсистемы
// "Получение обновлений программы".
//
Процедура ОбновлениеИнформационнойБазы_ОбновитьНастройкиПолученияОбновлений_2_1_8_1() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		// Не используется при работе в модели сервиса.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Перенос настроек проверки наличия обновлений
	// из СтандартныеПодсистемы.ОбновлениеКонфигурации,
	// преобразование существующих настроек БИП.
	
	ТипСтруктура = Тип("Структура");
	СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ТекПользователь Из СписокПользователей Цикл
		
		ИмяПользователя = ТекПользователь.Имя;
		
		НастройкиБИП = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ИнтеррнетПоддержка",
			"ПолучениеОбновленийПрограммы",
			,
			,
			ИмяПользователя);
		
		Если ТипЗнч(НастройкиБИП) = ТипСтруктура
			И НастройкиБИП.Свойство("СпособАвтоматическойПроверки") Тогда
			НастройкиБИП.Вставить("РежимАвтоматическойПроверкиНаличияОбновленийПрограммы",
				НастройкиБИП.СпособАвтоматическойПроверки);
			НастройкиБИП.Удалить("СпособАвтоматическойПроверки");
		КонецЕсли;
		
		НастройкиБСП = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ОбновлениеКонфигурации",
			"НастройкиОбновленияКонфигурации",
			,
			,
			ИмяПользователя);
		
		Если ТипЗнч(НастройкиБСП) = ТипСтруктура
			И НастройкиБСП.Свойство("ПроверятьНаличиеОбновленияПриЗапуске")
			И НастройкиБСП.ПроверятьНаличиеОбновленияПриЗапуске <> 0 Тогда
			
			Если ТипЗнч(НастройкиБИП) <> ТипСтруктура Тогда
				НастройкиБИП = ПолучениеОбновленийПрограммыКлиентСервер.НовыйНастройкиАвтоматическогоОбновления();
			КонецЕсли;
			
			НастройкиБИП.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы =
				НастройкиБСП.ПроверятьНаличиеОбновленияПриЗапуске;
			НастройкиБИП.Расписание =
				НастройкиБСП.РасписаниеПроверкиНаличияОбновления;
			
		КонецЕсли;
		
		Если ТипЗнч(НастройкиБИП) = ТипСтруктура Тогда
			// Если настройки были изменены, сохранить настройки.
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
				"ИнтеррнетПоддержка",
				"ПолучениеОбновленийПрограммы",
				НастройкиБИП,
				,
				ИмяПользователя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
