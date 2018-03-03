﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбновлениеИнформационнойБазыУТ.ПроверитьВозможностьОткрытияФормы(Метаданные.РегистрыСведений.РеестрДокументов.ПолноеИмя());
	
	Если Не Параметры.Свойство("КлючНазначенияФормы")
		Или ПустаяСтрока(Параметры.КлючНазначенияФормы) Тогда
		КлючНазначенияИспользования = КлючНазначенияФормыПоУмолчанию();
		КлючНастроек = "";
	Иначе
		КлючНазначенияИспользования = Параметры.КлючНазначенияФормы;
		КлючНастроек                = Параметры.КлючНазначенияФормы;
	КонецЕсли;
	
	ФормыОткрытаПоГиперссылке = Параметры.Свойство("ОтборыФормыСписка");
	
	Если ФормыОткрытаПоГиперссылке Тогда
		ОтборСклад = Параметры.ОтборыФормыСписка.ОтборСклад;
		ОтборТипыДокументов = Параметры.ОтборыФормыСписка.ОтборТипыДокументов;
		ОтборХозяйственныеОперации = Параметры.ОтборыФормыСписка.ОтборХозяйственныеОперации;
	Иначе
		ВосстановитьНастройки();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты,, Ложь);
	// Конец МенюОтчеты
	
	// ПроверкаДокументовВРеглУчете
	//++ НЕ УТ
	ПроверкаДокументовСервер.ДоработатьЗапросДинамическогоСпискаЖурналаДокументов(СписокОформлено.ТекстЗапроса, "РеестрДокументов");
	//-- НЕ УТ
	СписокОформлено.ТекстЗапроса = СтрЗаменить(СписокОформлено.ТекстЗапроса, "&СтатусПроверки КАК СтатусПроверки,", "");
	СписокОформлено.ТекстЗапроса = СтрЗаменить(СписокОформлено.ТекстЗапроса, "&ИндикаторПроверки КАК ИндикаторПроверки,", "");
	// Конец ПроверкаДокументовВРеглУчете
	
	ДополнительныеПараметры = Новый Структура("МестоРазмещенияДанныхПроверкиРегл", Элементы.ГруппаРеглПроверка);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	НастроитьЭлементыФормыПриСоздании();
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(ИнформационнаяНадписьОтбор, ХозяйственныеОперацииИДокументы, ОтборТипыДокументов, ОтборХозяйственныеОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	ПодключитьОбработчикОжиданияГиперссылкиКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(ПодключаемоеОборудованиеУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ВнутреннееПотреблениеТоваров"
		Или ИмяСобытия = "Запись_ВозвратМатериаловИзПроизводства" 
		Или ИмяСобытия = "Запись_ВыпускПродукции" 
		Или ИмяСобытия = "Запись_ОприходованиеИзлишковТоваров" 
		Или ИмяСобытия = "Запись_ПередачаМатериаловВПроизводство" 
		Или ИмяСобытия = "Запись_ДвижениеПродукцииИМатериалов" 
		Или ИмяСобытия = "Запись_ПеремещениеТоваров" 
		Или ИмяСобытия = "Запись_ПересортицаТоваров" 
		Или ИмяСобытия = "Запись_ПорчаТоваров" 
		Или ИмяСобытия = "Запись_ПрочееОприходованиеТоваров" 
		Или ИмяСобытия = "Запись_СборкаТоваров" 
		Или ИмяСобытия = "Запись_СписаниеНедостачТоваров"
		Или ИмяСобытия = "Запись_ЗаказНаСборку"
		Или ИмяСобытия = "Запись_ЗаказНаПроизводство"
		Или ИмяСобытия = "Запись_ЗаказНаПеремещение"
		Или ИмяСобытия = "Запись_ЗаказНаВнутреннееПотребление"
		Или ИмяСобытия = "Запись_ЗаказМатериаловВПроизводство"
		Или ИмяСобытия = "Запись_РасходныйОрдерНаТовары"
		Или ИмяСобытия = "Запись_ПриходныйОрдерНаТовары" Тогда
		
		ПерезаполнитьСтраницы(Источник);
		ПодключитьОбработчикОжиданияГиперссылкиКОформлению();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область КнопкаСоздать

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтборы = Новый Структура("Склад",ОтборСклад);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтборы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокументЧерезФормуВыбора(Команда)
	КлючФормы = КлючНазначенияФормыПоУмолчанию();
	АдресХозяйственныеОперацииИДокументы = ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы();
	СтруктураОтборы = Новый Структура("Склад",ОтборСклад);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезФормуВыбора(АдресХозяйственныеОперацииИДокументы,
		КлючФормы, КлючНазначенияИспользования, СтруктураОтборы);
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписокОформлено);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.СписокОформлено);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.СписокОформлено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяНадписьОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДоступныеХозяйственныеОперацииИДокументы", ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы());
	
	ПараметрыФормы.Вставить("КлючНастроек", КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("КлючФормы", КлючНазначенияФормыПоУмолчанию());
	
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.Форма.ФормаУстановкиОтбора",
	ПараметрыФормы,,,,,Новый ОписаниеОповещения("УстановитьОтборыПоХозОперациямИДокументам", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоХозОперациямИДокументам(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
		
		АдресДоступныхХозяйственныхОперацийИДокументов = ВыбранноеЗначение;
		
		ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов);
		ПодключитьОбработчикОжиданияГиперссылкиКОформлению();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)

	ПерезаполнитьСтраницы();
	ПодключитьОбработчикОжиданияГиперссылкиКОформлению();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(ИнтервалОформленныхДокументов, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьСтатус(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьСтатус(Команда.Имя, СоответствиеКомандСтатусам, Элементы.СписокОформлено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокОформлено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокОформлено, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокОформлено, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокОформлено, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КОформлениюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияФормы", КлючНазначенияИспользования);
	ОтборыФормыСписка = Новый Структура;	
	ОтборыФормыСписка.Вставить("ОтборСклад", ОтборСклад);
	ОтборыФормыСписка.Вставить("ОтборТипыДокументов", ОтборТипыДокументов);
	ОтборыФормыСписка.Вставить("ОтборХозяйственныеОперации", ОтборХозяйственныеОперации);
	ПараметрыФормы.Вставить("ОтборыФормыСписка", ОтборыФормыСписка);
		
	ПараметрыФормы.Вставить("ФиксированныеНастройки", Неопределено);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", Новый ПользовательскиеНастройкиКомпоновкиДанных);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	Если ЗначениеЗаполнено(ОтборСклад) Тогда
		КлючВарианта = "ОформлениеИзлишковНедостачКонтекст";
		ПараметрыФормы.Вставить("Склад", ОтборСклад);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Склад", ОтборСклад)); 
	Иначе
		КлючВарианта = "ОформлениеИзлишковНедостач";
	КонецЕсли;
	
	ПараметрыФормы.Вставить("КлючВарианта", КлючВарианта);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", КлючВарианта);

	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки,ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОформлено

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПриАктивизацииСтроки(Элемент)
	
	УправлениеПечатьюКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаСервере
Функция ДанныеПоШтрихКодуПечатнойФормы(Штрихкод)
	
	ДанныеПоШтрихКоду = ОбщегоНазначенияУТ.ДанныеПоШтрихКодуПечатнойФормы(Штрихкод, ХозяйственныеОперацииИДокументы.Выгрузить());	
	
	Возврат ДанныеПоШтрихКоду;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	Состояние(НСтр("ru = 'Выполняется поиск документа по штрихкоду...'"));
	ДанныеПоШтрихКоду = ДанныеПоШтрихКодуПечатнойФормы(Данные.Штрихкод);
	ОбщегоНазначенияУТКлиент.ОбработатьШтрихкоды(Данные.Штрихкод, ДанныеПоШтрихКоду, ЭтаФорма, "СписокОформлено");
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриИзмененииОтбора()
	
	СохранитьНастройки();
	УстановитьОтборыДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		МассивСсылок = ДополнительныеПараметры.ВыделенныеСтроки;
		ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
		
		УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры);
		
		Если МассивСсылок.Количество() > 1 Тогда
			Документ = Заголовок;
			ТекстОповещения = ?(Не ПометитьНаУдаление, 
				НСтр("ru='Пометка удаления снята (%КоличествоДокументов%)'"),
				НСтр("ru='Пометка удаления установлена (%КоличествоДокументов%)'"));
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", МассивСсылок.Количество());
		Иначе
			Документ = Элементы.СписокОформлено.ТекущиеДанные.Ссылка;
			ТекстОповещения = ?(Не ПометитьНаУдаление,
				НСтр("ru='Пометка удаления снята'"),
				НСтр("ru='Пометка удаления установлена'"));
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры)
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		Документ = Строка.Ссылка;
		ДокументОбъект = Документ.ПолучитьОбъект();
		
		// Запись только тех объектов, значение пометки которых меняется
		Если ПометитьНаУдаление И НЕ ДокументОбъект.ПометкаУдаления Тогда
			ДокументОбъект.ПометкаУдаления = Истина;
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		ИначеЕсли НЕ ПометитьНаУдаление И ДокументОбъект.ПометкаУдаления Тогда
			ДокументОбъект.ПометкаУдаления = Ложь;
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность(ТекущийКлюч)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		Элементы.ОтборСклад.Видимость = Ложь;
	КонецЕсли;
	
	// Перезаполнение списка статусов
	ОбщегоНазначенияУТ.УстановитьСписокСтатусов(ЭтаФорма, Элементы.УстановитьСтатус);
	
	ОбъектыМетаданных = ОбщегоНазначенияУТ.ОбъектыМетаданныхИзХозяйственныхОперацийИДокументов(ХозяйственныеОперацииИДокументы);
	ОбщегоНазначенияУТ.УстановитьОтборыПечать(ЭтаФорма, Элементы.ПодменюПечать, ОбъектыМетаданных);
	ОбщегоНазначенияУТ.УстановитьОтборыВводНаОсновании(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании, ОбъектыМетаданных);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьДокументыИспользующиеСтатус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокОформлено.Дата", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьСтраницы(ДокументДляПересчета = Неопределено)
	
	ПриИзмененииОтбора();
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Обработки.ЖурналДокументовВнутреннегоТовародвижения.ИнициализироватьХозяйственныеОперацииИДокументы(
		ХозяйственныеОперацииИДокументы.Выгрузить(),
		ОтборХозяйственныеОперации,
		ОтборТипыДокументов,
		КлючНастроек);
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
	ЗаполнитьДоступныеТипыЗаказовИТипыНакладных();
	РассчитатьНеобходимостьОтображенияКолонок();
	
	УстановитьОтборыДинамическогоСписка();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		Если Параметры.СтруктураБыстрогоОтбора.Свойство("ПолноеИмяДокумента") Тогда
						
			Отбор = Новый Структура();
			Отбор.Вставить("ПолноеИмяДокумента", Параметры.СтруктураБыстрогоОтбора.ПолноеИмяДокумента);
			
			НайденныеСтроки = ХозяйственныеОперацииИДокументы.НайтиСтроки(Отбор);
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				НайденнаяСтрока.Отбор = Истина;
			КонецЦикла;
			
			ЗаполнитьДоступныеТипыЗаказовИТипыНакладных();
			РассчитатьНеобходимостьОтображенияКолонок();
			
		КонецЕсли;
	КонецЕсли;
	
	НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов();
	Элементы.Склад.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов()
	
	ДанныеРабочегоМеста = ОбщегоНазначенияУТ.ДанныеРабочегоМеста(
		ХозяйственныеОперацииИДокументы.Выгрузить(), 
		КлючНазначенияФормыПоУмолчанию(), 
		НСтр("ru = 'Внутренние документы (все)'"));
		
	УстановитьВидимостьДоступность(ДанныеРабочегоМеста.КлючНазначенияИспользования);
	
	ОбновитьГиперссылкуКОформлению();
	
	Заголовок = ДанныеРабочегоМеста.ЗаголовокРабочегоМеста;
	
	НастроитьКнопкиУправленияДокументами();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокОформлено,
		"ХозяйственнаяОперация",
		ОтборХозяйственныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокОформлено,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокОформлено,
		"Склад",
		ОтборСклад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборСклад));
	
	СписокОформлено.Параметры.УстановитьЗначениеПараметра("НачалоПериода", ИнтервалОформленныхДокументов.ДатаНачала);
	СписокОформлено.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		?(ЗначениеЗаполнено(ИнтервалОформленныхДокументов.ДатаОкончания),
			КонецДня(ИнтервалОформленныхДокументов.ДатаОкончания),
			ИнтервалОформленныхДокументов.ДатаОкончания));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок()
	
	Элементы.СписокОформлено.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеТипыЗаказовИТипыНакладных()
	
	ОтборТипов = Новый Структура();
	ОтборТипов.Вставить("Накладная", Ложь);
	ОтборТипов.Вставить("ИспользуетсяРаспоряжение", Истина);
		
	ПолныеИменаЗаказов.ЗагрузитьЗначения(
		ОбщегоНазначенияУТ.ИспользуемыеПолныеИменаДокументов(ХозяйственныеОперацииИДокументы.Выгрузить(), ОтборТипов));
	
	ОтборТипов = Новый Структура();
	ОтборТипов.Вставить("Накладная", Истина);
	
	ПолныеИменаНакладных.ЗагрузитьЗначения(ОбщегоНазначенияУТ.ИспользуемыеПолныеИменаДокументов( 
		ХозяйственныеОперацииИДокументы.Выгрузить(),
		ОтборТипов));
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьНеобходимостьОтображенияКолонок()
	
	НакладныеСоСтатусами = ХозяйственныеОперацииИДокументы.НайтиСтроки(Новый Структура("Отбор, ИспользуютсяСтатусы", Истина, Истина));
	
	ЕстьДокументыИспользующиеСтатус = НакладныеСоСтатусами.Количество() <> 0;
			
КонецПроцедуры

&НаСервере
Процедура ОтборОперацияТипОбработкаВыбораСервер(АдресДоступныхХозяйственныхОперацийИДокументов)
	
	ТаблицаХозяйственныеОперацииИДокументы = ПолучитьИзВременногоХранилища(АдресДоступныхХозяйственныхОперацийИДокументов);
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаХозяйственныеОперацииИДокументы);
	
	ОбщегоНазначенияУТ.ЗаполнитьОтборыПоТаблицеХозОперацийИТиповДокументов(ТаблицаХозяйственныеОперацииИДокументы, ОтборХозяйственныеОперации, ОтборТипыДокументов);
	
	ЗаполнитьДоступныеТипыЗаказовИТипыНакладных();
	РассчитатьНеобходимостьОтображенияКолонок();
	НастроитьФормуПоНастройкамХозяйственныхОперацийИДокументов();
	
	ПриИзмененииОтбора();
	ОбщегоНазначенияУТ.СформироватьНадписьОтбор(ИнформационнаяНадписьОтбор, ХозяйственныеОперацииИДокументы, ОтборТипыДокументов, ОтборХозяйственныеОперации);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияФормыПоУмолчанию()
	
	Возврат "ВнутреннееТовародвижение";
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройки()
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ЖурналДокументовВнутреннегоТовародвижения.Форма.ФормаСписка", КлючНазначенияИспользования);
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
	
		ИнтервалОформленныхДокументов = Настройки.ИнтервалОформленныхДокументов;
		ОтборСклад = Настройки.ОтборСклад;
		
		Настройки.Свойство("ОтборХозяйственныеОперации", ОтборХозяйственныеОперации);
		Настройки.Свойство("ОтборТипыДокументов", ОтборТипыДокументов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	Если ФормыОткрытаПоГиперссылке Тогда
		Возврат;
	КонецЕсли;
	
	ИменаСохраняемыхРеквизитов =
		"ИнтервалОформленныхДокументов,
		|ОтборСклад,
		|ОтборХозяйственныеОперации,
		|ОтборТипыДокументов";
	
	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ЖурналДокументовВнутреннегоТовародвижения.Форма.ФормаСписка", КлючНазначенияИспользования, Настройки);
	
КонецПроцедуры

#Область РаботаСКешируемымиЗначениями

&НаСервере
Функция ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы()
	Возврат ПоместитьВоВременноеХранилище(ХозяйственныеОперацииИДокументы.Выгрузить(), УникальныйИдентификатор);
КонецФункции

#КонецОбласти

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтаФорма;
	СтруктураПараметров.ИмяКнопкиСкопировать 								= "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню 				= "СписокСкопировать1";
	СтруктураПараметров.ИмяКнопкиИзменить 									= "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню 					= "СписокИзменить1";
	СтруктураПараметров.ИмяКнопкиПровести 									= "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню 					= "СписокПровести1";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения 							= "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню 			= "СписокОтменаПроведения1";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления 					= "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню 	= "СписокУстановитьПометкуУдаления1";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

КонецПроцедуры

&НаКлиенте
Процедура СписокОформленоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда 
		Если Копирование Тогда
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
		ИначеЕсли ОтборТипыДокументов.Количество() = 1 И ОтборХозяйственныеОперации.Количество() = 1 Тогда 
			СтруктураКоманды = Новый Структура("Имя", Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0].Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
		Иначе
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
		КонецЕсли;
	КонецЕсли;
	Отказ = Истина;

КонецПроцедуры

#Область ГиперссылкаКОформлению

&НаСервере
Процедура ОбновитьГиперссылкуКОформлению()
	
	// Проверка возможности отображения элемента формы КОформлению
	
	Отбор = Новый Структура("Отбор", Истина);
	ХозОперацииИДокументы = ХозяйственныеОперацииИДокументы.НайтиСтроки(Отбор);
	
	ДоступныеТипыНакладныхИЗаказов = Обработки.ЖурналДокументовВнутреннегоТовародвижения.ТипыРаспоряженийИНакладных(ХозОперацииИДокументы);
	
	НеобходимаГиперссылкаКОформлению = Ложь;
	ИспользуютсяРаспоряжения = Ложь;
	
	Для Каждого Строка Из ХозОперацииИДокументы Цикл
		
		Если ЗначениеЗаполнено(Строка.МенеджерРасчетаГиперссылкиКОформлению) Тогда
			НеобходимаГиперссылкаКОформлению = Истина;
		КонецЕсли;
			
		Если Строка.ПолноеИмяДокумента = Метаданные.Документы.СборкаТоваров.ПолноеИмя() Тогда
			ИспользуютсяРаспоряжения = ИспользуютсяРаспоряжения
				Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку");
		ИначеЕсли Строка.ПолноеИмяДокумента = Метаданные.Документы.ВнутреннееПотреблениеТоваров.ПолноеИмя() Тогда
			ИспользуютсяРаспоряжения = ИспользуютсяРаспоряжения
				Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаВнутреннееПотребление");
		ИначеЕсли Строка.ПолноеИмяДокумента = Метаданные.Документы.ПеремещениеТоваров.ПолноеИмя() Тогда
			ИспользуютсяРаспоряжения = ИспользуютсяРаспоряжения
				Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаПеремещение");
			//++ НЕ УТ
		ИначеЕсли Строка.ПолноеИмяДокумента = Метаданные.Документы.ПередачаМатериаловВПроизводство.ПолноеИмя() Тогда
			ИспользуютсяРаспоряжения = ИспользуютсяРаспоряжения
				Или ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
			//-- НЕ УТ
			//++ НЕ УТКА
		ИначеЕсли Строка.ПолноеИмяДокумента = Метаданные.Документы.ДвижениеПродукцииИМатериалов.ПолноеИмя() Тогда
			ИспользуютсяРаспоряжения = Истина;
			//-- НЕ УТКА
		КонецЕсли;
		
	КонецЦикла;
	
	ИспользоватьОрдерныеСклады = ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныеСклады");
	
	Если Не НеобходимаГиперссылкаКОформлению
		Или Не ИспользоватьОрдерныеСклады
			И Не ИспользуютсяРаспоряжения Тогда
		// В элементе формы КОформлению не могут быть отображены никакие данные
		Элементы.КОформлению.Видимость = Ложь;
		Возврат;
	Иначе
		Элементы.КОформлению.Видимость = Истина;
	КонецЕсли;
	
	ТекстИдетОбновлениеДанных = НСтр("ru = 'К оформлению: <идет обновление данных>'");
	КОформлению = Новый ФорматированнаяСтрока(ТекстИдетОбновлениеДанных);
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Склад", ОтборСклад);
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ХозяйственныеОперацииИДокументы.Выгрузить());
	ПараметрыЗадания.Добавить(ПараметрыФормирования);
	
	РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
						УникальныйИдентификатор,
						"Обработки.ЖурналДокументовВнутреннегоТовародвижения.СформироватьГиперссылкуКОформлениюФоновоеЗадание",
						ПараметрыЗадания);
	
	АдресХранилища       = РезультатРасчета.АдресХранилища;
	ИдентификаторЗадания = РезультатРасчета.ИдентификаторЗадания;
	
	Если РезультатРасчета.ЗаданиеВыполнено Тогда
		КОформлению = ПолучитьИзВременногоХранилища(АдресХранилища);
	КонецЕсли;
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Документ.ТранспортнаяНакладная");
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(НСтр("ru = 'См. также:'") + " ");
		
	Для Каждого МенеджерРасчетаСмТакжеВРаботе Из МассивМенеджеровРасчетаСмТакжеВРаботе Цикл
		Если МенеджерРасчетаСмТакжеВРаботе = "" Тогда
			Продолжить;
		КонецЕсли;
		
		Гиперссылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МенеджерРасчетаСмТакжеВРаботе).СформироватьГиперссылкуСмТакжеВРаботе(ПараметрыФормирования);
		
		Если ЗначениеЗаполнено(Гиперссылка) Тогда
			Если МассивСтрок.Количество()>1 Тогда
				МассивСтрок.Добавить("; ");
			КонецЕсли;
			МассивСтрок.Добавить(Гиперссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивСтрок.Количество() = 1 Тогда
		СмТакжеВРаботе = Неопределено;
	Иначе
		СмТакжеВРаботе = Новый ФорматированнаяСтрока(МассивСтрок)
	КонецЕсли;
	
	Элементы.СмТакжеВРаботе.Видимость = ЗначениеЗаполнено(СмТакжеВРаботе);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияГиперссылкиКОформлению()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьГиперссылкуКОформлениюЗавершение()
	
	КОформлению = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если Не ЗначениеЗаполнено(КОформлению) Тогда
		ТекстИдетОбновлениеДанных = НСтр("ru = 'К оформлению: нет'");
		КОформлению = Новый ФорматированнаяСтрока(ТекстИдетОбновлениеДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	
	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		
		ОбновитьГиперссылкуКОформлениюЗавершение();
		
	Иначе
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	УправлениеПечатьюКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокОформлено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

#КонецОбласти

#КонецОбласти
