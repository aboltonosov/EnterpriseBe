﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ВидыЗапасов.Количество() > 0 Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Сделка");
	КонецЕсли;
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Менеджер");
	КонецЕсли;
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НоваяСделка");
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НовыйМенеджер");
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НовоеПодразделение");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	Если Предназначение = НовоеПредназначение Тогда
		
		ТекстОшибки = "";
		Если Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки
		 И ЗначениеЗаполнено(Сделка)
		 И Сделка = НоваяСделка Тогда
			ТекстОшибки = НСтр("ru='Исходная сделка равна новой сделке'");
			Поле = "Сделка";
		КонецЕсли;
	 
		Если Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера
		 И ЗначениеЗаполнено(Менеджер)
		 И Менеджер = НовыйМенеджер Тогда
			ТекстОшибки = НСтр("ru='Исходной менеджер равен новому менеджеру'");
			Поле = "Менеджер";
		КонецЕсли;
	 
		Если Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения
		 И ЗначениеЗаполнено(Подразделение)
		 И Подразделение = НовоеПодразделение Тогда
			ТекстОшибки = НСтр("ru='Исходное подразделение равно новому подразделению'");
			Поле = "Подразделение";
		КонецЕсли;
		
		Если Предназначение = Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначениеНеОграничено Тогда
			ТекстОшибки = НСтр("ru='Исходное предназначение равно новому предназначению'");
			Поле = "Предназначение";
		КонецЕсли;
		
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
	 		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				Поле,
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов));
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		Сделка = Неопределено;
	КонецЕсли;
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		Менеджер = Неопределено;
	КонецЕсли;
	
	Если Предназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		Подразделение = Неопределено;
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки Тогда
		НоваяСделка = Неопределено;
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера Тогда
		НовыйМенеджер = Неопределено;
	КонецЕсли;
	
	Если НовоеПредназначение <> Перечисления.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения Тогда
		НовоеПодразделение = Неопределено;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета, Склад, Подразделение, Неопределено);
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.Назначение = "";
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
		
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.КорректировкаОбособленногоУчетаЗапасов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&Предназначение КАК Предназначение,
	|	&Подразделение КАК Подразделение,
	|	&Менеджер КАК Менеджер,
	|	&Сделка КАК Сделка,
	|
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти
	|	
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	&Склад КАК Склад,
	|	ТаблицаТоваров.ДокументРеализации КАК ДокументРеализации,
	|	&Сделка КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов
	|
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	&Сделка КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ДокументРеализации КАК ДокументРеализации,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Предназначение", Предназначение);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(Товары.Выгрузить()));
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ЗапасыСервер.ТаблицаДополненнаяОбязательнымиКолонками(ВидыЗапасов.Выгрузить()));
	
	Запрос.Выполнить();
	
	Если ВидыЗапасовУказаныВручную Тогда
		ДополнительныеСвойства.Вставить("ИгнорироватьОперативныеОстатки", Истина);
	КонецЕсли;
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		Истина
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Склад КАК Склад,
	|	ДанныеДокумента.Предназначение КАК Предназначение,
	|	ДанныеДокумента.Сделка КАК Сделка,
	|	ДанныеДокумента.Менеджер КАК Менеджер,
	|	ДанныеДокумента.Подразделение КАК Подразделение
	|
	|ПОМЕСТИТЬ СохраненныеДанныеДокумента
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Организация <> СохраненныеДанные.Организация ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Склад <> СохраненныеДанные.Склад ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Предназначение <> СохраненныеДанные.Предназначение ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Подразделение <> СохраненныеДанные.Подразделение ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Менеджер <> СохраненныеДанные.Менеджер ТОГДА
	|		Истина
	|	КОГДА ДанныеДокумента.Сделка <> СохраненныеДанные.Сделка ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК РеквизитыИзменены
	|ИЗ
	|	ТаблицаДанныхДокумента КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СохраненныеДанныеДокумента КАК СохраненныеДанные
	|	ПО
	|		Истина
	|");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		РеквизитыИзменены = Выборка.РеквизитыИзменены;
	Иначе
		РеквизитыИзменены = Ложь;
	КонецЕсли;
	
	Возврат РеквизитыИзменены;
	
КонецФункции

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|// Собственные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца,
	|	ВидыЗапасов.Предназначение КАК Предназначение,
	|	ВидыЗапасов.Сделка КАК Сделка,
	|	ВидыЗапасов.Менеджер КАК Менеджер,
	|	ВидыЗапасов.Подразделение КАК Подразделение
	|
	|ПОМЕСТИТЬ ВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И Не ВидыЗапасов.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Предназначение
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|
	|// Не обособленные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначениеНеОграничено)
	|	И &Сделка = ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)
	|	И &Менеджер = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	И &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по сделке
	|ВЫБРАТЬ
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки)
	|	И ВидыЗапасов.Сделка = &Сделка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по менеджеру
	|ВЫБРАТЬ
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера)
	|	И ВидыЗапасов.Менеджер = &Менеджер
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по подразделению
	|ВЫБРАТЬ
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения)
	|	И ВидыЗапасов.Подразделение = &Подразделение
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Предназначение", Предназначение);
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц)
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
	 	СтруктураАналитики = ЗапасыСервер.АналитикаОбособленноУчетаДокумента(МенеджерВременныхТаблиц);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Корректировка превышает остаток товара организации %1 на складе %2 %3 %4'"),
			Организация,
			Склад,
			СтруктураАналитики.СтрокаАналитики,
			СтруктураАналитики.Аналитика);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Номенклатура: %1, недостаточно %2 %3'"),
				НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.Характеристика),
				СтрокаТаблицы.Количество,
				СтрокаТаблицы.ЕдиницаИзмерения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ДополнительныеСвойства.Свойство("ПерезаполнитьВидыЗапасов");
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ РеквизитыДокументаИзменились(МенеджерВременныхТаблиц)
	 ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличеству(МенеджерВременныхТаблиц) Тогда
	 
		СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
		ЗапасыСервер.УстановитьБлокировкуОстатковТоваровОрганизаций(МенеджерВременныхТаблиц);
		ЗапасыСервер.ТаблицаОстатковТоваровОрганизаций(Ссылка, Организация, Дата, ДополнительныеСвойства, МенеджерВременныхТаблиц);
		ТаблицаОшибок = ЗапасыСервер.ТаблицаОшибокЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовДокумента(
			МенеджерВременныхТаблиц,
			ДополнительныеСвойства,
			ВидыЗапасов,
			ТаблицаОшибок,
			Отказ);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество");
		СообщитьОбОшибкахЗаполненияВидовЗапасов(ТаблицаОшибок, МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	Массив = Новый Массив;
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
